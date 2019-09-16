import React, { Component } from 'react'
import axios from 'axios'

import ProductTable from '../content/ProductTable'
import ProductForm from '../content/ProductForm'

class Products extends Component {
  state = {
    products: [],
    submitDisabled: false,
    responseMessage: ''
  };

  componentDidMount() {
    axios
      .get('/api/products')
      .then(response => {
        this.setState({ products: response.data.products });
      })
  }

  deleteProduct = (id) => {
    axios
      .delete(`/api/products/${id}`)
      .then(response => {
        if (response.data.success) {
          this.setState({ products: [...this.state.products.filter(product => product.id !== id)] });
        } else {
          this.setState({ responseMessage: response.data.errors });
        }
      })
  }

  createProduct = (productParams) => {
    this.setState({ submitDisabled: true });

    axios
      .post('/api/products', productParams)
      .then(response => {
        if (response.data.success) {
          this.setState({ products: [...this.state.products, response.data.success.product]});
        } else {
          this.setState({ responseMessage: response.data.errors });
        }

        this.setState({ submitDisabled: false });
      })
  }

  render() {
    return (
      <React.Fragment>
        <ProductForm createProduct={this.createProduct} submitDisabled={this.state.submitDisabled}></ProductForm>
        <div>{this.state.responseMessage}</div>
        <ProductTable products={this.state.products} deleteProduct={this.deleteProduct}></ProductTable>
      </React.Fragment>
    )
  }
}

export default Products
