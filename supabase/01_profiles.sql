-- Tabla de perfiles de usuario (extiende auth.users de Supabase)
create table profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  nombre text,
  rol text default 'user' check (rol in ('admin', 'user')),
  created_at timestamptz default now()
);

-- Seguridad: cada usuario solo ve y edita su propio perfil
alter table profiles enable row level security;

create policy "usuarios ven su propio perfil"
  on profiles for select
  using (auth.uid() = id);

create policy "usuarios editan su propio perfil"
  on profiles for update
  using (auth.uid() = id);

-- Crea el perfil automáticamente cuando alguien se registra
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into profiles (id, nombre)
  values (new.id, new.raw_user_meta_data->>'nombre');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();
