import React from 'react';
import type { CartData } from '../types/cart';

interface CartPaneProps {
  cart: CartData;
  loading: boolean;
  onAddToCart: (code: string) => void;
  onRemoveFromCart: (code: string) => void;
}

const CartPane: React.FC<CartPaneProps> = ({ cart, loading, onAddToCart, onRemoveFromCart }) => {
  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-2xl font-semibold text-gray-800 mb-4">
        Cart ({cart.item_count} items)
      </h2>
      
      {cart.items.length === 0 ? (
        <p className="text-gray-500 text-center py-8">Your cart is empty</p>
      ) : (
        <>
          <div className="overflow-x-auto mb-4">
            <table className="w-full table-auto">
              <thead>
                <tr className="bg-gray-50">
                  <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Item</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Unit Price</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Quantity</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Discount</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {cart.items.map((item) => (
                  <tr key={item.code} className="hover:bg-gray-50">
                    <td className="px-4 py-3">
                      <div>
                        <div className="font-medium text-gray-900">{item.name}</div>
                        <div className="text-sm text-gray-500">Code: {item.code}</div>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-900">{item.unit_price}</td>
                    <td className="px-4 py-3 text-sm text-gray-900">{item.quantity}</td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {item.discount_rule || 'None'}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex space-x-2">
                        <button
                          onClick={() => onAddToCart(item.code)}
                          disabled={loading}
                          className="bg-green-500 hover:bg-green-600 disabled:bg-green-300 text-white px-3 py-1 rounded text-sm font-medium transition-colors"
                          title="Add one more"
                        >
                          +
                        </button>
                        <button
                          onClick={() => onRemoveFromCart(item.code)}
                          disabled={loading}
                          className="bg-red-500 hover:bg-red-600 disabled:bg-red-300 text-white px-3 py-1 rounded text-sm font-medium transition-colors"
                          title="Remove one"
                        >
                          -
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="border-t pt-4">
            <div className="flex justify-between items-center">
              <span className="text-xl font-semibold text-gray-800">Total:</span>
              <span className="text-2xl font-bold text-green-600">{cart.total}</span>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default CartPane;