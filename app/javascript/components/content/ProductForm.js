import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ProductForm extends Component {
  state = {
    ext_id: '',
    use_proxy: false
  };

  handleChange = event => {
    this.setState({ [event.target.name]: event.target.value });
  }

  handleToggle = event => {
    const use_proxy = event.target.checked;
    this.setState({ use_proxy });
  }

  onSubmit = (event) => {
    event.preventDefault();

    this.props.createProduct(this.state);
    this.setState({ ext_id: '' });
  }

  render() {
    return (
      <div className="product_form">
        <form onSubmit={this.onSubmit}>
          <input
            name="ext_id"
            placeholder="ID of Product"
            type="text"
            maxLength="25"
            value={this.state.ext_id}
            onChange={this.handleChange}
          />

          <input
            id="proxy"
            name="use_proxy"
            type="checkbox"
            checked={this.state.use_proxy}
            onChange={this.handleToggle}
          />

          <label htmlFor="proxy">Use proxy? (fetch will be slower)</label>

          <input
            type="submit"
            value="Retrieve Product Information!"
            disabled={this.props.submitDisabled}
          />
        </form>
        <div className={this.props.submitDisabled ? 'fa fa-spin fa-spinner' : 'hide'} />
      </div>
    )
  }
}

ProductForm.propTypes = {
  createProduct: PropTypes.func.isRequired,
  submitDisabled: PropTypes.bool.isRequired
}

export default ProductForm
