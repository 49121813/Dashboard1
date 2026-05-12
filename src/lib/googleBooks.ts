import type { GoogleBook } from "./types";

const API_KEY = import.meta.env.GOOGLE_BOOKS_API_KEY;
const BASE_URL = "https://www.googleapis.com/books/v1/volumes";

export async function buscarLibros(query: string, maxResults = 20): Promise<GoogleBook[]> {
  const params = new URLSearchParams({
    q: query,
    maxResults: String(maxResults),
    ...(API_KEY ? { key: API_KEY } : {}),
  });

  const res = await fetch(`${BASE_URL}?${params}`);
  if (!res.ok) throw new Error(`Google Books API error: ${res.status}`);

  const data = await res.json();
  return (data.items ?? []) as GoogleBook[];
}

export async function getLibro(bookId: string): Promise<GoogleBook> {
  const params = API_KEY ? `?key=${API_KEY}` : "";
  const res = await fetch(`${BASE_URL}/${bookId}${params}`);
  if (!res.ok) throw new Error(`Google Books API error: ${res.status}`);
  return res.json() as Promise<GoogleBook>;
}
