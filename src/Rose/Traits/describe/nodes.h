#ifndef Rose_Traits_describe_nodes_h
#define Rose_Traits_describe_nodes_h

#include "Rose/Traits/describe/fields.h"

namespace Rose {
namespace Traits {

/**
 * Describes an AST node
 *
 * \tparam NodeT
 *
 * Build the final node descriptor using the descriptors generated by Rosetta.
 *
 * \link DescribeNode<void>
 *
 */
template <typename NodeT>
struct DescribeNode : generated::describe_node_t<NodeT> {
  using fields_t = typename generated::describe_node_t<NodeT>::fields_t::template map_t<details::transcribe_field_desc_t>;
};


/**
 * For documentation purpose.
 * Equivalent to instantiating `DescribeNode` with any else that a Rose AST class (aka: `bool isAstNode<T> ~= std::is_same<DescribeNode<T>, void>::value`)
 */
template <>
struct DescribeNode<void> {
  using node = void;                            //!< the node's `SgXXX`  
  using base = void;                            //!< the parent `SgXXX` in the hierarchy
  static constexpr char const * const name{""}; //!< string representation of the class' name: "XXX"
  static constexpr unsigned long variant{0};    //!< numerical variant of the node
  static constexpr bool concrete{false};        //!< whether it is a concrete grammar node
  using subclasses_t = mp::List<>;              //!< `Rose::mp::List` of `SgXXX` that descend from this node
  using fields_t = mp::List<>;                  //!< `Rose::mp::List` of `Rose::Traits::DescribeField` instances (from list of `Rose::Traits::generated::describe_field_t`)
};

} }

#endif /* Rose_Traits_describe_nodes_h */
