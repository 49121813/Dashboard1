create table favoritos (
  id uuid default gen_random_uuid() primary key,
  usuario_id uuid references profiles(id) on delete cascade not null,
  book_id text not null,
  titulo text not null,
  autores text,
  thumbnail text,
  added_at timestamptz default now(),
  unique(usuario_id, book_id)
);

alter table favoritos enable row level security;

create policy "usuarios ven sus favoritos"
  on favoritos for select
  using (auth.uid() = usuario_id);

create policy "usuarios agregan favoritos"
  on favoritos for insert
  with check (auth.uid() = usuario_id);

create policy "usuarios eliminan sus favoritos"
  on favoritos for delete
  using (auth.uid() = usuario_id);
