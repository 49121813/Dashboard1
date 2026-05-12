import { supabase } from "./supabase";
import type { Producto, Profile, Venta } from "./types";

// --- Productos ---
export async function getProductos() {
  const { data, error } = await supabase
    .from("productos")
    .select("*")
    .eq("activo", true)
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data as Producto[];
}

export async function crearProducto(p: Omit<Producto, "id" | "created_at">) {
  const { data, error } = await supabase.from("productos").insert(p).select().single();
  if (error) throw error;
  return data as Producto;
}

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

// --- Ventas / Métricas ---
export async function getVentas() {
  const { data, error } = await supabase
    .from("ventas")
    .select("*, productos(nombre)")
    .order("fecha", { ascending: false });
  if (error) throw error;
  return data as (Venta & { productos: { nombre: string } })[];
}

export async function getTotalVentas() {
  const { data, error } = await supabase
    .from("ventas")
    .select("total");
  if (error) throw error;
  return (data as { total: number }[]).reduce((acc, v) => acc + v.total, 0);
}
