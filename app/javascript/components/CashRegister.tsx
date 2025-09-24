import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';

import type { Product } from '../types/product';
import { fetchProducts } from '../api/products';
import ProductsPane from './ProductsPane';

const CashRegisterApp: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);

  // Fetch products on component mount
  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      const productsData = await fetchProducts();
      setProducts(productsData);
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <ProductsPane 
        products={products} 
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