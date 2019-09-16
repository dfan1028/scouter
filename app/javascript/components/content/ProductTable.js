import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ProductTable extends Component {

  renderBody = () => {
    return(
      this.props.products.map(product => (
        <tr key={product.ext_id}>
          <td>{product.ext_id}</td>
          <td>{product.category}</td>
          <td>{product.rank}</td>
          <td>{product.dimensions}</td>
          <td><button onClick={this.props.deleteProduct.bind(this, product.id)}>Delete</button></td>
        </tr>
      ))
    )
  }

  render() {
    return (
      <table className='table'>
        <thead>
          <tr>
            <td>External ID</td>
            <td>Category</td>
            <td>Rank</td>
            <td>Dimensions</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          { this.renderBody() }
        </tbody>
      </table>
    )
  }
}

ProductTable.propTypes = {
  products: PropTypes.array.isRequired,
  deleteProduct: PropTypes.func.isRequired
}

export default ProductTable
