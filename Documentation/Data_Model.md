# Data Model

The project uses a relational e-commerce data model consisting of six tables.

## Tables

### Categories

Contains product category information.

- category_id
- category_name

### Customers

Contains customer information.

- customer_id
- name
- email
- signup_date
- city
- state

### Products

Contains product and pricing information.

- product_id
- product_name
- category_id
- price
- cost_price

### Orders

Contains order-level information.

- order_id
- customer_id
- order_status
- payment_method

### Order Items

Contains product-level details for each order.

- order_item_id
- order_id
- product_id
- quantity
- unit_price

### Returns

Contains return information at the order-item level.

- return_id
- order_item_id
- return_date
- refund_amount

## Key Relationships

- Categories → Products
- Customers → Orders
- Orders → Order Items
- Products → Order Items
- Order Items → Returns

## Data Model Structure

The model follows a relational structure where:

- Categories are connected to Products through `category_id`.
- Customers are connected to Orders through `customer_id`.
- Orders are connected to Order Items through `order_id`.
- Products are connected to Order Items through `product_id`.
- Order Items are connected to Returns through `order_item_id`.

This structure supports sales, profitability, customer, product, and returns analysis.
