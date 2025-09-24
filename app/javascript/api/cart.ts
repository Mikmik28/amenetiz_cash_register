import { CartData } from "../types/cart";

export const addToCart = async (
  code: string
): Promise<{
  message: string;
  cart: Record<string, number>;
  total_items: number;
}> => {
  const response = await fetch("/api/v1/cart/add", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ code }),
  });

  if (!response.ok) {
    throw new Error("Failed to add item to cart");
  }

  return response.json();
};

export const removeFromCart = async (
  code: string
): Promise<{
  message: string;
  cart: Record<string, number>;
  total_items: number;
}> => {
  const response = await fetch("/api/v1/cart/remove", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ code }),
  });

  if (!response.ok) {
    throw new Error("Failed to remove item from cart");
  }

  return response.json();
};

export const fetchCartData = async (): Promise<CartData> => {
  const response = await fetch("/api/v1/cart");
  if (!response.ok) {
    throw new Error("Failed to fetch cart data");
  }
  return response.json();
};
