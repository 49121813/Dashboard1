-- Solo recrea la función y el trigger (la tabla ya existe)
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into profiles (id, nombre)
  values (new.id, new.raw_user_meta_data->>'nombre');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();
