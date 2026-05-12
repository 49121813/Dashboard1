import { supabase } from "./supabase";
import type { Favorito, Profile } from "./types";

// --- Perfiles ---
export async function getProfile(userId: string) {
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", userId)
    .single();
  if (error) throw error;
  return data as Profile;
}

// --- Favoritos ---
export async function getFavoritos(userId: string) {
  const { data, error } = await supabase
    .from("favoritos")
    .select("*")
    .eq("usuario_id", userId)
    .order("added_at", { ascending: false });
  if (error) throw error;
  return data as Favorito[];
}

export async function agregarFavorito(
  userId: string,
  book: Pick<Favorito, "book_id" | "titulo" | "autores" | "thumbnail">
) {
  const { error } = await supabase
    .from("favoritos")
    .insert({ usuario_id: userId, ...book });
  if (error) throw error;
}

export async function eliminarFavorito(userId: string, bookId: string) {
  const { error } = await supabase
    .from("favoritos")
    .delete()
    .eq("usuario_id", userId)
    .eq("book_id", bookId);
  if (error) throw error;
}
