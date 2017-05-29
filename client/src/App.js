import React, { Component } from 'react';
import Client from './Client';

class App extends Component {
  state = {
    items: [],
    page: 1
  };

  componentDidMount() {
    Client.search(this.state, (items) => {
      this.setState({items: items});
    });
  };

  handleNextPage = (e) => {
    let newState = this.state;
    newState.page += 1;

    this.setState({page: newState.page});

    Client.search(newState, (items) => {
      this.setState({items: items});
    });
  };

  render() {
    const itemRows = this.state.items.map((item, index) => (
      <tr>
        <td>{item.title}</td>
        <td>{item.artist}</td>
        <td>{item.year}</td>
        <td>{item.label}</td>
        <td>{item.format}</td>
        <td>{item.condition}</td>
        <td>{item.color}</td>
        <td>{item.price_paid}</td>
        <td>
          {
            item.discogs_url &&
            <a href={item.discogs_url}>link</a>
          }
        </td>
        <td>{item.notes}</td>
        <td>{item.created_at}</td>
      </tr>
    ));

    return (
      <div className="App">
        <h1>Rayons</h1>

        <table>
          {itemRows}
        </table>

        <button onClick={this.handlePreviousPage}>Previous</button>
        <button onClick={this.handleNextPage}>Next</button>
      </div>
    );
  };
};

export default App;
