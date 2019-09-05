from pb_protocol.common_pb2 import *
from google.protobuf.pyext.cpp_message import GeneratedProtocolMessageType
from sakura.version_tools import v_iteritems

COMMON_PB2_DATA = {k: v for k, v in v_iteritems(locals()) if isinstance(v, GeneratedProtocolMessageType)}
