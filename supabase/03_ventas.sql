create table ventas (
  id uuid default gen_random_uuid() primary key,
  producto_id uuid references productos(id) on delete restrict not null,
  usuario_id uuid references profiles(id) on delete restrict not null,
  cantidad integer not null check (cantidad > 0),
  total numeric(10,2) not null check (total >= 0),
  fecha timestamptz default now()
);

alter table ventas enable row level security;

create policy "usuarios ven sus propias ventas"
  on ventas for select
  using (auth.uid() = usuario_id);

create policy "admins ven todas las ventas"
  on ventas for select
  using (
    exists (
      select 1 from profiles
      where profiles.id = auth.uid()
      and profiles.rol = 'admin'
    )
  );

create policy "usuarios crean ventas propias"
  on ventas for insert
  with check (auth.uid() = usuario_id);
