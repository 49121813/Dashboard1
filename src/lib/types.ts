export type Rol = "admin" | "user";

export interface Profile {
  id: string;
  nombre: string | null;
  rol: Rol;
  created_at: string;
}

export interface Favorito {
  id: string;
  usuario_id: string;
  book_id: string;
  titulo: string;
  autores: string | null;
  thumbnail: string | null;
  added_at: string;
}

// Formato que devuelve Google Books API
export interface GoogleBook {
  id: string;
  volumeInfo: {
    title: string;
    authors?: string[];
    description?: string;
    categories?: string[];
    imageLinks?: {
      thumbnail?: string;
      smallThumbnail?: string;
    };
    publishedDate?: string;
    pageCount?: number;
    language?: string;
  };
}
