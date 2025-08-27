# Stock Management Implementation

## Overview
This implementation adds comprehensive stock management functionality to the POS app, ensuring that stock levels are properly tracked and updated when products are added to or removed from the cart.

## Key Features

### 1. Stock Validation
- **Stock Applicable Check**: Only products with `stockApplicable = 1` are subject to stock management
- **Stock Availability**: Prevents adding products to cart when stock is insufficient
- **Real-time Validation**: Stock is checked before any cart operations

### 2. Stock Reservation System
- **Reserve on Add**: Stock is reserved when products are added to cart
- **Release on Remove**: Stock is released when products are removed from cart
- **Quantity Management**: Handles quantity changes with proper stock updates

### 3. Database Integration
- **Local Storage**: Stock updates are persisted to local Hive database
- **Real-time Updates**: Product stock levels are updated immediately
- **Error Handling**: Graceful error handling for database operations

### 4. User Feedback
- **Stock Warnings**: Low stock warnings (≤5 items remaining)
- **Error Messages**: Clear error messages for insufficient stock
- **Success Messages**: Confirmation when products are added/removed

## Implementation Details

### StockUtils Class (`lib/data/utils/stock_utils.dart`)
```dart
class StockUtils {
  // Check if product can be added to cart
  static bool canAddToCart(ProductModel product, int quantity)
  
  // Reserve stock when adding to cart
  static bool reserveStock(ProductModel product, int quantity)
  
  // Release stock when removing from cart
  static void releaseStock(ProductModel product, int quantity)
  
  // Get stock status for display
  static String getStockStatus(ProductModel product)
  
  // Check if product is out of stock
  static bool isOutOfStock(ProductModel product)
  
  // Check if product has low stock
  static bool isLowStock(ProductModel product)
}
```

### CartBloc Integration (`lib/logic/cart_logic/cart_bloc.dart`)
- **AddToCartEvent**: Validates and reserves stock before adding
- **UpdateCartQuantityEvent**: Handles stock updates for quantity changes
- **Stock Validation**: Prevents cart operations when stock is insufficient

### Product Card Updates (`lib/widgets/item_card_widget.dart`)
- **Stock Check**: Validates stock before adding to cart
- **User Feedback**: Shows appropriate messages for stock status
- **Disabled State**: Prevents adding out-of-stock items

### Sale Window Updates (`lib/presentation/screens/dashboard/counter_sale/sale_window.dart`)
- **Stock Validation**: Checks stock before adding products
- **Error Handling**: Shows clear error messages for stock issues

## Stock Management Flow

### Adding Products to Cart
1. **Stock Check**: Validate if sufficient stock is available
2. **Reserve Stock**: Decrease available stock in database
3. **Add to Cart**: Add product to cart if stock is available
4. **User Feedback**: Show success/error messages

### Removing Products from Cart
1. **Release Stock**: Increase available stock in database
2. **Remove from Cart**: Remove product from cart
3. **User Feedback**: Show confirmation message

### Updating Quantities
1. **Calculate Difference**: Determine stock change needed
2. **Validate New Quantity**: Check if new quantity is available
3. **Update Stock**: Reserve or release stock as needed
4. **Update Cart**: Update cart with new quantity

## Stock Status Indicators

### Stock Levels
- **In Stock**: Normal stock levels (>5 items)
- **Low Stock**: Warning level (≤5 items remaining)
- **Out of Stock**: No items available (≤0 items)

### Visual Indicators
- **Stock Badge**: Shows current stock level on product cards
- **Color Coding**: Different colors for different stock levels
- **Warning Messages**: Automatic warnings for low stock

## Error Handling

### Insufficient Stock
- **Validation**: Prevents adding more items than available
- **User Message**: Clear error message with available stock
- **Graceful Degradation**: App continues to function normally

### Database Errors
- **Error Logging**: Logs database operation errors
- **User Notification**: Shows error message to user
- **Fallback**: Continues operation without stock update if needed

## Testing Scenarios

### 1. Normal Stock Operations
- Add products with sufficient stock
- Remove products from cart
- Update quantities within available stock

### 2. Low Stock Scenarios
- Add products when stock is low (≤5 items)
- Verify low stock warnings appear
- Test adding more than available stock

### 3. Out of Stock Scenarios
- Try to add out-of-stock products
- Verify error messages appear
- Test cart operations with zero stock

### 4. Edge Cases
- Rapid quantity changes
- Multiple users/sessions
- Database connection issues
- Invalid stock values

## Configuration

### Stock Thresholds
- **Low Stock Threshold**: 5 items (configurable in StockUtils)
- **Out of Stock Threshold**: 0 items
- **Stock Applicable Flag**: `stockApplicable = 1` for stock-managed products

### Database Settings
- **Local Storage**: Hive database for offline operation
- **Sync**: Stock updates are local (server sync can be added later)
- **Backup**: Stock data is persisted locally

## Future Enhancements

### 1. Server Integration
- **Stock Sync**: Sync stock levels with server
- **Real-time Updates**: Live stock updates across devices
- **Conflict Resolution**: Handle concurrent stock updates

### 2. Advanced Features
- **Stock Alerts**: Push notifications for low stock
- **Stock History**: Track stock changes over time
- **Stock Reports**: Generate stock level reports

### 3. Performance Optimizations
- **Batch Updates**: Batch stock operations for better performance
- **Caching**: Cache stock levels for faster access
- **Background Sync**: Sync stock in background

## Usage Examples

### Adding Product to Cart
```dart
// Check stock availability
if (StockUtils.canAddToCart(product, 1)) {
  // Reserve stock and add to cart
  if (StockUtils.reserveStock(product, 1)) {
    context.read<CartBloc>().add(AddToCartEvent(product: product));
  }
}
```

### Removing Product from Cart
```dart
// Release stock when removing
StockUtils.releaseStock(product, quantity);
context.read<CartBloc>().add(UpdateCartQuantityEvent(product: product, quantity: 0));
```

### Checking Stock Status
```dart
// Get stock status for display
String status = StockUtils.getStockStatus(product);

// Check if out of stock
if (StockUtils.isOutOfStock(product)) {
  // Handle out of stock scenario
}
```

## Troubleshooting

### Common Issues
1. **Stock Not Updating**: Check database permissions and connection
2. **Incorrect Stock Levels**: Verify stock calculations and database updates
3. **Performance Issues**: Consider batch operations for large inventories

### Debug Information
- **Logs**: Check console logs for stock operation details
- **Database**: Verify stock values in Hive database
- **UI**: Check stock badges and status messages

## Conclusion

This stock management implementation provides a robust foundation for inventory control in the POS app. It ensures accurate stock tracking, prevents overselling, and provides clear user feedback for all stock-related operations.

The system is designed to be:
- **Reliable**: Handles edge cases and errors gracefully
- **User-friendly**: Clear messages and visual indicators
- **Scalable**: Can be extended with server integration
- **Maintainable**: Well-structured code with clear separation of concerns 