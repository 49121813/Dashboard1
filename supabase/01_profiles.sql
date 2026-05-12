create table profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  nombre text,
  rol text default 'user' check (rol in ('admin', 'user')),
  created_at timestamptz default now()
);

alter table profiles enable row level security;

create policy "usuarios ven su propio perfil"
  on profiles for select using (auth.uid() = id);

create policy "usuarios editan su propio perfil"
  on profiles for update using (auth.uid() = id);

create policy "trigger crea perfil al registrarse"
  on profiles for insert with check (true);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, nombre)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'nombre', split_part(new.email, '@', 1))
  );
  return new;
exception when others then
  return new;
end;
$$ language plpgsql security definer set search_path = public;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
