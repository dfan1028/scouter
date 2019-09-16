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

  setSubmitDisabled = (isDisabled) => {
    this.setState({ submitDisabled: isDisabled });
  }

  setResponseMessage = (message) => {
    this.setState({ responseMessage: message });
  }

  deleteProduct = (id) => {
    this.setResponseMessage("");

    axios
      .delete(`/api/products/${id}`)
      .then(response => {
        this.setState({ products: [...this.state.products.filter(product => product.id !== id)] });
      })
      .catch(error => {
        this.setResponseMessage(error.response.data.errors);
      });
  }

  createProduct = (productParams) => {
    this.setSubmitDisabled(true);
    this.setResponseMessage("");

    axios
      .post('/api/products', productParams)
      .then(response => {
        this.setState({ products: [...this.state.products, response.data.success.product]});
        this.setSubmitDisabled(false);
      })
      .catch(error => {
        this.setResponseMessage(error.response.data.errors);
        this.setSubmitDisabled(false);
      });
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
