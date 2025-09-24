import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';

import type { Product } from '../types/product';
import type { CartData } from '../types/cart';
import { fetchProducts } from '../api/products';
import { fetchCartData, addToCart as addToCartApi, removeFromCart as removeFromCartApi } from '../api/cart';
import ProductsPane from './ProductsPane';
import CartPane from './CartPane';

const CashRegisterApp: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [cart, setCart] = useState<CartData>({ items: [], total: '$0.00', total_cents: 0, item_count: 0 });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadProducts();
    loadCart();
  }, []);

  const loadProducts = async () => {
    try {
      const productsData = await fetchProducts();
      setProducts(productsData);
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

  const loadCart = async () => {
    try {
      const cartData = await fetchCartData();
      setCart(cartData);
    } catch (error) {
      console.error('Error loading cart:', error);
    }
  };

  const handleAddToCart = async (code: string) => {
    setLoading(true);
    try {
      await addToCartApi(code);
      await loadCart(); // Refresh cart data
    } catch (error) {
      console.error('Error adding to cart:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRemoveFromCart = async (code: string) => {
    setLoading(true);
    try {
      await removeFromCartApi(code);
      await loadCart();
    } catch (error) {
      console.error('Error removing from cart:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <ProductsPane 
        products={products} 
        loading={loading} 
        onAddToCart={handleAddToCart} 
      />

      <CartPane 
        cart={cart}
        loading={loading}
        onAddToCart={handleAddToCart}
        onRemoveFromCart={handleRemoveFromCart}
      />
    </div>
  );
};

// Mount the component when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('cash-register-app');
  if (container) {
    const root = createRoot(container);
    root.render(<CashRegisterApp />);
  }
});

export default CashRegisterApp;