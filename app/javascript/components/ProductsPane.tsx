import React from 'react';
import type { Product } from '../types/product';

interface ProductsPaneProps {
  products: Product[];
}

const ProductsPane: React.FC<ProductsPaneProps> = ({ products }) => {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 mb-8">
      <h2 className="text-2xl font-semibold text-gray-800 mb-4">Products</h2>
      <div className="overflow-x-auto">
        <table className="w-full table-auto">
          <thead>
            <tr className="bg-gray-50">
              <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Product</th>
              <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Price</th>
              <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Discount</th>
              <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {products.map((product) => (
              <tr key={product.id} className="hover:bg-gray-50">
                <td className="px-4 py-3">
                  <div>
                    <div className="font-medium text-gray-900">{product.name}</div>
                    <div className="text-sm text-gray-500">Code: {product.code}</div>
                  </div>
                </td>
                <td className="px-4 py-3 text-sm text-gray-900">{product.price}</td>
                <td className="px-4 py-3 text-sm text-gray-600">
                  {product.discount_rule || 'None'}
                </td>
                <td className="px-4 py-3">
                  <button
                    className="bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 text-white px-4 py-2 rounded text-sm font-medium transition-colors"
                  >
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ProductsPane;