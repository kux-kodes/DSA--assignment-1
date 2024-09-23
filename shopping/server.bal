import ballerina/grpc;
import ballerina/protobuf;

public const string CHATGPT_DESC = "0A0D636861746770742E70726F746F120F6F6E6C696E655F73686F7070696E6722A6010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512160A06737461747573180620012809520673746174757322440A0E50726F647563745265717565737412320A0770726F6475637418012001280B32182E6F6E6C696E655F73686F7070696E672E50726F64756374520770726F64756374225F0A0F50726F64756374526573706F6E736512180A076D65737361676518012001280952076D65737361676512320A0770726F6475637418022001280B32182E6F6E6C696E655F73686F7070696E672E50726F64756374520770726F64756374221D0A0950726F64756374496412100A03736B751801200128095203736B7522430A0B50726F647563744C69737412340A0870726F647563747318012003280B32182E6F6E6C696E655F73686F7070696E672E50726F64756374520870726F647563747322330A045573657212170A07757365725F6964180120012809520675736572496412120A04726F6C651802200128095204726F6C6522380A0B557365725265717565737412290A047573657218012001280B32152E6F6E6C696E655F73686F7070696E672E5573657252047573657222280A0C55736572526573706F6E736512180A076D65737361676518012001280952076D65737361676522380A0B436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B7522280A0C43617274526573706F6E736512180A076D65737361676518012001280952076D65737361676522210A0655736572496412170A07757365725F69641801200128095206757365724964226E0A0D4F72646572526573706F6E736512180A076D65737361676518012001280952076D65737361676512430A106F7264657265645F70726F647563747318022003280B32182E6F6E6C696E655F73686F7070696E672E50726F64756374520F6F72646572656450726F647563747322070A05456D70747932FE040A0F53686F7070696E6753657276696365124F0A0A41646450726F64756374121F2E6F6E6C696E655F73686F7070696E672E50726F64756374526571756573741A202E6F6E6C696E655F73686F7070696E672E50726F64756374526573706F6E7365124C0A0B4372656174655573657273121C2E6F6E6C696E655F73686F7070696E672E55736572526571756573741A1D2E6F6E6C696E655F73686F7070696E672E55736572526573706F6E7365280112520A0D55706461746550726F64756374121F2E6F6E6C696E655F73686F7070696E672E50726F64756374526571756573741A202E6F6E6C696E655F73686F7070696E672E50726F64756374526573706F6E736512490A0D52656D6F766550726F64756374121A2E6F6E6C696E655F73686F7070696E672E50726F6475637449641A1C2E6F6E6C696E655F73686F7070696E672E50726F647563744C697374124D0A154C697374417661696C61626C6550726F647563747312162E6F6E6C696E655F73686F7070696E672E456D7074791A1C2E6F6E6C696E655F73686F7070696E672E50726F647563744C697374124D0A0D53656172636850726F64756374121A2E6F6E6C696E655F73686F7070696E672E50726F6475637449641A202E6F6E6C696E655F73686F7070696E672E50726F64756374526573706F6E736512480A09416464546F43617274121C2E6F6E6C696E655F73686F7070696E672E43617274526571756573741A1D2E6F6E6C696E655F73686F7070696E672E43617274526573706F6E736512450A0A506C6163654F7264657212172E6F6E6C696E655F73686F7070696E672E5573657249641A1E2E6F6E6C696E655F73686F7070696E672E4F72646572526573706F6E7365620670726F746F33";

public isolated client class ShoppingServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CHATGPT_DESC);
    }

    isolated remote function AddProduct(ProductRequest|ContextProductRequest req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductRequest message;
        if req is ContextProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function AddProductContext(ProductRequest|ContextProductRequest req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductRequest message;
        if req is ContextProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(ProductRequest|ContextProductRequest req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductRequest message;
        if req is ContextProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function UpdateProductContext(ProductRequest|ContextProductRequest req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductRequest message;
        if req is ContextProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(ProductId|ContextProductId req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductId message;
        if req is ContextProductId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function RemoveProductContext(ProductId|ContextProductId req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductId message;
        if req is ContextProductId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(Empty|ContextEmpty req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function ListAvailableProductsContext(Empty|ContextEmpty req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(ProductId|ContextProductId req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductId message;
        if req is ContextProductId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function SearchProductContext(ProductId|ContextProductId req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductId message;
        if req is ContextProductId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(CartRequest|ContextCartRequest req) returns CartResponse|grpc:Error {
        map<string|string[]> headers = {};
        CartRequest message;
        if req is ContextCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CartResponse>result;
    }

    isolated remote function AddToCartContext(CartRequest|ContextCartRequest req) returns ContextCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        CartRequest message;
        if req is ContextCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

