export interface Product {
  id: number;
  code: string;
  name: string;
  price: string;
  price_cents: number;
  discount_rule?: string;
}
