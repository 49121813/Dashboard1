-- Permite que el trigger inserte el perfil al registrarse
create policy "trigger crea perfil al registrarse"
  on profiles for insert
  with check (true);
