# Dialog param it's a param for selected dialog answer, for example, if
# player select: i'm ready to quest, we take him a item, or something else
# and this class will contain:
# param_name "Give Torch"
# param_value "Torch"
# param_type ParamType.Item

class_name DialogAttributeSetter

enum AttributeType { Item, Quest, Attribute }

var attribute_name: String
var attribute_value: String
var attribute_type: AttributeType
