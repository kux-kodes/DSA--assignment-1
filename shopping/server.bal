import ballerina/http;

type Product record {
    string id;
    string name;
    string description;
    float price;
    int stock_quantity;
    string sku;
    string status;
};

type ProductResponse record {
    string message;
    Product product;
};

type ProductID record {
    string id;
};

type ProductListResponse record {
    Product[] products;
};

type ProductSKU record {
    string sku;
};

type User record {
    string id;
    string name;
    string email;
    string role;
};

type UserID record {
    string user_id;
};

type AddToCartRequest record {
    string user_id;
    string product_sku;
};

type CartResponse record {
    string message;
};

type OrderResponse record {
    string order_id;
    Product[] ordered_products;
    string message;
};

type UserCart record {
    string product_sku;
    int quantity;
};

// Simulated in-memory product storage with initial products
map<Product> products = {
    "sku001": { id: "1", name: "Laptop", description: "High performance laptop", price: 999.99, stock_quantity: 10, sku: "sku001", status: "Available" },
    "sku002": { id: "2", name: "Smartphone", description: "Latest model smartphone", price: 499.99, stock_quantity: 15, sku: "sku002", status: "Available" },
    "sku003": { id: "3", name: "Tablet", description: "Portable tablet", price: 299.99, stock_quantity: 20, sku: "sku003", status: "Available" }
};

map<User> users = {};
map<UserCart[]> userCarts = {}; // Maps user_id to an array of UserCart

service /shopping on new http:Listener(8080) {

    resource function post AddProduct(Product product) returns ProductResponse {
        products[product.sku] = product;
        return { message: "Product added successfully", product: product };
    }

    resource function put UpdateProduct(Product product) returns ProductResponse {
        products[product.sku] = product;
        return { message: "Product updated successfully", product: product };
    }

    resource function delete RemoveProduct(ProductID productId) returns ProductListResponse {
        _ = products.remove(productId.id);
        
        Product[] updatedProductList = [];
        foreach string key in products.keys() {
            updatedProductList.push(<Product>products[key]);
        }
        
        return { products: updatedProductList };
    }

    resource function get ListAvailableProducts() returns ProductListResponse {
        Product[] availableProducts = [];
        foreach string key in products.keys() {
            Product p = <Product>products[key];
            if (p.status == "Available") {
                availableProducts.push(p);
            }
        }
        return { products: availableProducts };
    }

    resource function post SearchProduct(ProductSKU productSKU) returns ProductResponse {
        Product? product = products[productSKU.sku];
        if (product is Product) {
            return { message: "Product found", product: product };
        } else {
            return { message: "Product not found", product: { id: "", name: "", description: "", price: 0.0, stock_quantity: 0, sku: "", status: "" } };
        }
    }

    resource function post CreateUsers(User[] newUsers) returns string {
        foreach User user in newUsers {
            users[user.id] = user;
        }
        return "Users created successfully";
    }

   resource function post AddToCart(AddToCartRequest request) returns CartResponse {
    string userId = request.user_id;
    string productSku = request.product_sku;

    // Initialize the user's cart if it doesn't exist
    if (!userCarts.hasKey(userId)) {
        userCarts[userId] = [];
    }

    // Safely get the user's cart, ensuring it's not null
    UserCart[] cart = <UserCart[]>userCarts[userId];

    boolean productExists = false;

    // Iterate over the cart to check for the product
    foreach UserCart item in cart {
        if (item.product_sku == productSku) {
            item.quantity += 1; // Increment quantity
            productExists = true;
            break;
        }
    }

    // If the product is not in the cart, add it
    if (!productExists) {
        cart.push({ product_sku: productSku, quantity: 1 });
    }

    // Update the user's cart
    userCarts[userId] = cart; // Ensure to assign back the updated cart

    return { message: "Product added to cart successfully" };
}

    resource function post PlaceOrder(UserID userId) returns OrderResponse {
    if (!userCarts.hasKey(userId.user_id)) {
        return { order_id: "", ordered_products: [], message: "No products in cart" };
    }

    // Safely get the user's cart
    UserCart[]? cart = userCarts[userId.user_id];

    // Initialize an empty array for ordered products
    Product[] orderedProducts = [];

    // Check if cart is not null
    if (cart is UserCart[]) {
        foreach UserCart item in cart {
            Product? product = products[item.product_sku];
            if (product is Product && product.stock_quantity >= item.quantity) {
                orderedProducts.push(product);
                product.stock_quantity -= item.quantity; // Decrement stock
            }
        }
    }

    // Clear the user's cart after placing the order
    _ = userCarts.remove(userId.user_id);

    return { order_id: "ORD" + userId.user_id, ordered_products: orderedProducts, message: "Order placed successfully" };
}

}
