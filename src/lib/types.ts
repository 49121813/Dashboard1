export type Rol = "admin" | "user";

export interface Profile {
  id: string;
  nombre: string | null;
  rol: Rol;
  created_at: string;
}

export interface Producto {
  id: string;
  nombre: string;
  precio: number;
  stock: number;
  categoria: string | null;
  activo: boolean;
  created_at: string;
}

export interface Venta {
  id: string;
  producto_id: string;
  usuario_id: string;
  cantidad: number;
  total: number;
  fecha: string;
}
