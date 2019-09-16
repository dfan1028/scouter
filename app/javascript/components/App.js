import React, { Component } from 'react'
import { Route, Switch } from 'react-router-dom'
import axios from 'axios'

import Header from './layout/Header'
import NoMatch from './layout/NoMatch'
import Home from './layout/Home'
import Products from './layout/Products'

class App extends Component {
  componentDidMount() {
    const token = document.querySelector('[name="csrf-token"]').content;
    axios.defaults.headers.common['X-CSRF-TOKEN'] = token;
  }

  render() {
    return (
      <React.Fragment>
        <Header />
        <Switch>
          <Route exact path="/" component={Home} />
          <Route exact path="/products" component={Products} />
          <Route component={NoMatch} />
        </Switch>
      </React.Fragment>
    )
  }
}

export default App
