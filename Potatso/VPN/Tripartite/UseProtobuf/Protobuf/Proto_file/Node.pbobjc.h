// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: node.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class BaseResponse;
@class Node;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NodeRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface NodeRoot : GPBRootObject
@end

#pragma mark - Node

typedef GPB_ENUM(Node_FieldNumber) {
  Node_FieldNumber_User = 1,
  Node_FieldNumber_Port = 2,
  Node_FieldNumber_Method = 3,
  Node_FieldNumber_Passwd = 4,
  Node_FieldNumber_Protocol = 5,
  Node_FieldNumber_Obfs = 6,
  Node_FieldNumber_Address = 7,
  Node_FieldNumber_Sn = 8,
  Node_FieldNumber_City = 9,
  Node_FieldNumber_Country = 10,
  Node_FieldNumber_Weight = 11,
  Node_FieldNumber_TransferEnable = 12,
  Node_FieldNumber_U = 13,
  Node_FieldNumber_D = 14,
  Node_FieldNumber_ForbiddenPort = 15,
};

@interface Node : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *user;
/** Test to see if @c user has been set. */
@property(nonatomic, readwrite) BOOL hasUser;

@property(nonatomic, readwrite, copy, null_resettable) NSString *port;
/** Test to see if @c port has been set. */
@property(nonatomic, readwrite) BOOL hasPort;

@property(nonatomic, readwrite, copy, null_resettable) NSString *method;
/** Test to see if @c method has been set. */
@property(nonatomic, readwrite) BOOL hasMethod;

@property(nonatomic, readwrite, copy, null_resettable) NSString *passwd;
/** Test to see if @c passwd has been set. */
@property(nonatomic, readwrite) BOOL hasPasswd;

@property(nonatomic, readwrite, copy, null_resettable) NSString *protocol;
/** Test to see if @c protocol has been set. */
@property(nonatomic, readwrite) BOOL hasProtocol;

@property(nonatomic, readwrite, copy, null_resettable) NSString *obfs;
/** Test to see if @c obfs has been set. */
@property(nonatomic, readwrite) BOOL hasObfs;

@property(nonatomic, readwrite, copy, null_resettable) NSString *address;
/** Test to see if @c address has been set. */
@property(nonatomic, readwrite) BOOL hasAddress;

@property(nonatomic, readwrite, copy, null_resettable) NSString *sn;
/** Test to see if @c sn has been set. */
@property(nonatomic, readwrite) BOOL hasSn;

@property(nonatomic, readwrite, copy, null_resettable) NSString *city;
/** Test to see if @c city has been set. */
@property(nonatomic, readwrite) BOOL hasCity;

@property(nonatomic, readwrite, copy, null_resettable) NSString *country;
/** Test to see if @c country has been set. */
@property(nonatomic, readwrite) BOOL hasCountry;

@property(nonatomic, readwrite) uint32_t weight;

@property(nonatomic, readwrite) BOOL hasWeight;
@property(nonatomic, readwrite, copy, null_resettable) NSString *transferEnable;
/** Test to see if @c transferEnable has been set. */
@property(nonatomic, readwrite) BOOL hasTransferEnable;

@property(nonatomic, readwrite) uint32_t u;

@property(nonatomic, readwrite) BOOL hasU;
@property(nonatomic, readwrite) uint32_t d;

@property(nonatomic, readwrite) BOOL hasD;
@property(nonatomic, readwrite, copy, null_resettable) NSString *forbiddenPort;
/** Test to see if @c forbiddenPort has been set. */
@property(nonatomic, readwrite) BOOL hasForbiddenPort;

@end

#pragma mark - NODE_GEN_REQUEST

typedef GPB_ENUM(NODE_GEN_REQUEST_FieldNumber) {
  NODE_GEN_REQUEST_FieldNumber_RequireNumber = 1,
};

@interface NODE_GEN_REQUEST : GPBMessage

@property(nonatomic, readwrite) uint32_t requireNumber;

@property(nonatomic, readwrite) BOOL hasRequireNumber;
@end

#pragma mark - NODE_GEN_RESPONSE

typedef GPB_ENUM(NODE_GEN_RESPONSE_FieldNumber) {
  NODE_GEN_RESPONSE_FieldNumber_BaseResponse = 1,
  NODE_GEN_RESPONSE_FieldNumber_NodesArray = 2,
};

@interface NODE_GEN_RESPONSE : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) BaseResponse *baseResponse;
/** Test to see if @c baseResponse has been set. */
@property(nonatomic, readwrite) BOOL hasBaseResponse;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Node*> *nodesArray;
/** The number of items in @c nodesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger nodesArray_Count;

@end

#pragma mark - NODE_RESET_REQUEST

typedef GPB_ENUM(NODE_RESET_REQUEST_FieldNumber) {
  NODE_RESET_REQUEST_FieldNumber_Id_p = 1,
};

@interface NODE_RESET_REQUEST : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;
/** Test to see if @c id_p has been set. */
@property(nonatomic, readwrite) BOOL hasId_p;

@end

#pragma mark - NODE_RESET_RESPONSE

typedef GPB_ENUM(NODE_RESET_RESPONSE_FieldNumber) {
  NODE_RESET_RESPONSE_FieldNumber_BaseResponse = 1,
  NODE_RESET_RESPONSE_FieldNumber_Node = 2,
};

@interface NODE_RESET_RESPONSE : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) BaseResponse *baseResponse;
/** Test to see if @c baseResponse has been set. */
@property(nonatomic, readwrite) BOOL hasBaseResponse;

@property(nonatomic, readwrite, strong, null_resettable) Node *node;
/** Test to see if @c node has been set. */
@property(nonatomic, readwrite) BOOL hasNode;

@end

#pragma mark - NODE_REMOVE_REQUEST

typedef GPB_ENUM(NODE_REMOVE_REQUEST_FieldNumber) {
  NODE_REMOVE_REQUEST_FieldNumber_IdsArray = 1,
};

@interface NODE_REMOVE_REQUEST : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *idsArray;
/** The number of items in @c idsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger idsArray_Count;

@end

#pragma mark - NODE_REMOVE_RESPONSE

typedef GPB_ENUM(NODE_REMOVE_RESPONSE_FieldNumber) {
  NODE_REMOVE_RESPONSE_FieldNumber_BaseResponse = 1,
};

@interface NODE_REMOVE_RESPONSE : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) BaseResponse *baseResponse;
/** Test to see if @c baseResponse has been set. */
@property(nonatomic, readwrite) BOOL hasBaseResponse;

@end

#pragma mark - NODE_LIST_REQUEST

typedef GPB_ENUM(NODE_LIST_REQUEST_FieldNumber) {
  NODE_LIST_REQUEST_FieldNumber_Method = 1,
  NODE_LIST_REQUEST_FieldNumber_Protocol = 2,
  NODE_LIST_REQUEST_FieldNumber_Obfs = 3,
  NODE_LIST_REQUEST_FieldNumber_Address = 4,
  NODE_LIST_REQUEST_FieldNumber_Id_p = 5,
  NODE_LIST_REQUEST_FieldNumber_City = 6,
  NODE_LIST_REQUEST_FieldNumber_Country = 7,
};

@interface NODE_LIST_REQUEST : GPBMessage

/** default get all, otherwise filter with options */
@property(nonatomic, readwrite, copy, null_resettable) NSString *method;
/** Test to see if @c method has been set. */
@property(nonatomic, readwrite) BOOL hasMethod;

@property(nonatomic, readwrite, copy, null_resettable) NSString *protocol;
/** Test to see if @c protocol has been set. */
@property(nonatomic, readwrite) BOOL hasProtocol;

@property(nonatomic, readwrite, copy, null_resettable) NSString *obfs;
/** Test to see if @c obfs has been set. */
@property(nonatomic, readwrite) BOOL hasObfs;

@property(nonatomic, readwrite, copy, null_resettable) NSString *address;
/** Test to see if @c address has been set. */
@property(nonatomic, readwrite) BOOL hasAddress;

@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;
/** Test to see if @c id_p has been set. */
@property(nonatomic, readwrite) BOOL hasId_p;

@property(nonatomic, readwrite, copy, null_resettable) NSString *city;
/** Test to see if @c city has been set. */
@property(nonatomic, readwrite) BOOL hasCity;

@property(nonatomic, readwrite, copy, null_resettable) NSString *country;
/** Test to see if @c country has been set. */
@property(nonatomic, readwrite) BOOL hasCountry;

@end

#pragma mark - NODE_LIST_RESPONSE

typedef GPB_ENUM(NODE_LIST_RESPONSE_FieldNumber) {
  NODE_LIST_RESPONSE_FieldNumber_BaseResponse = 1,
  NODE_LIST_RESPONSE_FieldNumber_NodesArray = 2,
};

@interface NODE_LIST_RESPONSE : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) BaseResponse *baseResponse;
/** Test to see if @c baseResponse has been set. */
@property(nonatomic, readwrite) BOOL hasBaseResponse;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Node*> *nodesArray;
/** The number of items in @c nodesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger nodesArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)