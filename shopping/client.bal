
import ballerina/http;
import ballerina/io;

// Define types for Product and responses
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

// Create a client for the shopping service
http:Client clientEndpoint = check new ("http://localhost:8080/shopping");

// Function to list available products
function listAvailableProducts() returns error? {
    ProductListResponse|error listResponse = clientEndpoint->get("/ListAvailableProducts");
    if (listResponse is ProductListResponse) {
        io:println("=== Available Products ===");
        foreach Product p in listResponse.products {
            io:println("ID: ", p.id, "\nName: ", p.name, "\nPrice: $", p.price, "\nDescription: ", p.description, "\nStock: ", p.stock_quantity, "\nStatus: ", p.status, "\n");
        }
    } else {
        io:println("Error fetching available products: ", listResponse);
    }
}

// Function to search for a product
function searchProduct(string sku) returns error? {
    ProductSKU searchSKU = { sku: sku };
    ProductResponse|error searchResponse = clientEndpoint->post("/SearchProduct", searchSKU);
    
    if (searchResponse is ProductResponse) {
        io:println("=== Search Result ===");
        io:println("Message: ", searchResponse.message);
        if (searchResponse.product.id != "") {
            io:println("Found Product: ");
            io:println("ID: ", searchResponse.product.id, "\nName: ", searchResponse.product.name, "\nPrice: $", searchResponse.product.price);
        }
    } else {
        io:println("Error searching for product: ", searchResponse);
    }
}

// Function to add a new product
function addProduct(Product newProduct) returns error? {
    ProductResponse|error addResponse = clientEndpoint->post("/AddProduct", newProduct);
    if (addResponse is ProductResponse) {
        io:println("=== Add Product Response ===");
        io:println("Message: ", addResponse.message);
        io:println("Product Added: ", newProduct.name);
    } else {
        io:println("Error adding product: ", addResponse);
    }
}

// Function to update an existing product
function updateProduct(Product updatedProduct) returns error? {
    ProductResponse|error updateResponse = clientEndpoint->put("/UpdateProduct", updatedProduct);
    if (updateResponse is ProductResponse) {
        io:println("=== Update Product Response ===");
        io:println("Message: ", updateResponse.message);
        io:println("Product Updated: ", updatedProduct.name);
    } else {
        io:println("Error updating product: ", updateResponse);
    }
}

// Function to remove a product
function removeProduct(string sku) returns error? {
    ProductID productId = { id: sku };
    ProductListResponse|error removeResponse = clientEndpoint->delete("/RemoveProduct", productId);
    if (removeResponse is ProductListResponse) {
        io:println("=== Remove Product Response ===");
        io:println("Products after removal:");
        foreach Product p in removeResponse.products {
            io:println("ID: ", p.id, "\nName: ", p.name, "\nPrice: $", p.price, "\nDescription: ", p.description, "\nStock: ", p.stock_quantity, "\nStatus: ", p.status, "\n");
        }
    } else {
        io:println("Error removing product: ", removeResponse);
    }
}

// Function to create multiple users
function createUsers(User[] users) returns error? {
    // Send the request and handle response correctly
    string|error response = clientEndpoint->post("/CreateUsers", users);
    if (response is string) {
        io:println("Users created successfully.");
    } else {
        io:println("Error creating users: ", response);
    }
}

// Function to add a product to the cart
function addToCart(string userId, string productSku) returns error? {
    AddToCartRequest request = { user_id: userId, product_sku: productSku };
    CartResponse|error response = clientEndpoint->post("/AddToCart", request);
    
    if (response is CartResponse) {
        io:println("Add to Cart Response: ", response.message);
    } else {
        io:println("Error adding to cart: ", response);
    }
}

// Function to place an order
function placeOrder(string userId) returns error? {
    UserID userIDRequest = { user_id: userId };
    OrderResponse|error response = clientEndpoint->post("/PlaceOrder", userIDRequest);
    
    if (response is OrderResponse) {
        io:println("Order placed successfully. Order ID: ", response.order_id);
        io:println("Ordered Products:");
        foreach Product p in response.ordered_products {
            io:println("ID: ", p.id, ", Name: ", p.name);
        }
    } else {
        io:println("Error placing order: ", response);
    }
}
// Main function
public function main() returns error? {
    // Example: List available products
    error? listAvailableProductsResult = listAvailableProducts();
    if listAvailableProductsResult is error {
        // Handle error
    }

    // Example: Search for a product with a fixed SKU value
    string sku = "sku001"; // Use an existing SKU from your product list
    error? searchProductResult = searchProduct(sku);
    if searchProductResult is error {
        io:println("Failed to search for product: ", searchProductResult);
    }

    // Example: Add a new product
    error? addProductResult = addProduct({ 
        id: "4", 
        name: "Smartwatch", 
        description: "Fitness smartwatch", 
        price: 199.99, 
        stock_quantity: 30, 
        sku: "sku004", 
        status: "Available" 
    });
    if addProductResult is error {
        // Handle error
    }

    // Example: Update an existing product
    error? updateProductResult = updateProduct({ 
        id: "1", 
        name: "Laptop", 
        description: "Updated high performance laptop", 
        price: 899.99, 
        stock_quantity: 5, 
        sku: "sku001", 
        status: "Available" 
    });
    if updateProductResult is error {
        // Handle error
    }

    // Example: Remove a product
    error? removeProductResult = removeProduct("sku002");
    if removeProductResult is error {
        // Handle error
    }

    // Example: Create multiple users
    User[] newUsers = [
        { id: "user1", name: "Alice", email: "alice@example.com", role: "Customer" },
        { id: "user2", name: "Bob", email: "bob@example.com", role: "Admin" }
    ];
    error? createUserResult = createUsers(newUsers);
    if createUserResult is error {
        // Handle error
    }

    // Example: Add to cart
    error? addToCartResult = addToCart("user1", "sku004");
    if addToCartResult is error {
        // Handle error
    }

    // Example: Place an order
    error? placeOrderResult = placeOrder("user1");
    if placeOrderResult is error {
        // Handle error
    }
}
