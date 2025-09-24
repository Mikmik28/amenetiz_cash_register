import { Product } from "../types/product";

export const fetchProducts = async (): Promise<Product[]> => {
  const response = await fetch("/api/v1/products");
  if (!response.ok) {
    throw new Error("Failed to fetch products");
  }
  return response.json();
};
