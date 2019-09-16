import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import App from '../components/App'

import { BrowserRouter as Router, Route } from 'react-router-dom'

document.addEventListener('DOMContentLoaded', () => {
  let appElement = document.createElement('div');

  appElement.setAttribute('id', 'scouter_app');
  appElement.setAttribute('class', 'container-fluid')

  ReactDOM.render(
    <Router>
      <Route path="/" component={App} />
    </Router>,
    document.body.appendChild(appElement)
  )
});
