create table productos (
  id uuid default gen_random_uuid() primary key,
  nombre text not null,
  precio numeric(10,2) not null check (precio >= 0),
  stock integer default 0 check (stock >= 0),
  categoria text,
  activo boolean default true,
  created_at timestamptz default now()
);

-- Solo admins pueden crear/editar/borrar productos
alter table productos enable row level security;

create policy "todos ven productos activos"
  on productos for select
  using (activo = true);

create policy "admins gestionan productos"
  on productos for all
  using (
    exists (
      select 1 from profiles
      where profiles.id = auth.uid()
      and profiles.rol = 'admin'
    )
  );
