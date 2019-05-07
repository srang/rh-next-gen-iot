import React, {Component} from 'react';
import {ListView} from 'patternfly-react';
import * as SockJS from 'sockjs-client'
import {Stomp} from '@stomp/stompjs'

export class PumpStatusItem extends Component {
    constructor(props) {
        super();
        this.checkToggle = this.checkToggle.bind(this);
        this.state = {
            stompClient: props.stompClient,
            checked: props.checked
        }
    }

    checkToggle(event) {
        this.setState({checked: event.target.checked});
        console.log(event.target.id);
        this.state.stompClient.send("/ws/pump/update", {},
            JSON.stringify({ pumpId: this.props.index, "active": event.target.checked}));
    }

    render() {
        return (
            <ListView.Item id={this.props.index}
                   key={this.props.index}
                   checkboxInput={<input type="checkbox" checked={this.state.checked} onChange={this.checkToggle}/>}
                   leftContent={<ListView.Icon name="wifi"/>}
                   heading={this.props.title}
                   description={this.props.description}
            >
            </ListView.Item>
        );
    }
}
