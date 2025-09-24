export interface CartItem {
  code: string;
  name: string;
  quantity: number;
  unit_price: string;
  discount_rule?: string;
}

export interface CartData {
  items: CartItem[];
  total: string;
  total_cents: number;
  item_count: number;
}
