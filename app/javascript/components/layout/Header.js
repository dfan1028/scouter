import React, { Component } from 'react'
import { Link } from 'react-router-dom'

// link from react-router-dom
class Header extends Component {
  render() {
    return (
      <React.Fragment>
        <div className='title_bar row'>
          <div className='scouter'></div>
          <h1>Gather data about your target! Destroy your enemies!</h1>
        </div>
        <div className='link_bar row'>
          <Link to="/">Home</Link>
          <Link to="/products">Products</Link>
        </div>
      </React.Fragment>
    )
  }
}

export default Header
