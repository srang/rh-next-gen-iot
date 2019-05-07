import React, {Component} from 'react';
import {ListView} from 'patternfly-react';
import {PumpStatusItem} from "./PumpStatusItem";
import * as SockJS from 'sockjs-client'
import {Stomp} from '@stomp/stompjs'

export class PumpControlView extends Component {
    constructor() {
        super();
        this.reconnectPumps = this.reconnectPumps(this);
        this.state = {
            stompClient: {},
            showResults: false,
            pumps: [
                {
                    id: 1,
                    active: true,
                    title: 'ESP Dataset 1',
                    description: 'Healthy Pump'
                },
                {
                    id: 2,
                    active: true,
                    title: 'ESP Dataset 2',
                    description: 'Healthy Pump'
                },
                {
                    id: 3,
                    active: true,
                    title: 'ESP Dataset 3',
                    description: 'Healthy -> Warning -> Healthy'
                },
                {
                    id: 4,
                    active: true,
                    title: 'ESP Dataset 4',
                    description: 'Pump Breakdown'
                },
                {
                    id: 5,
                    active: false,
                    title: 'ESP Dataset 5',
                    description: 'Healthy Pump'
                },
                {
                    id: 6,
                    active: false,
                    title: 'ESP Dataset 6',
                    description: 'Healthy Pump'
                },
                {
                    id: 7,
                    active: false,
                    title: 'ESP Dataset 7',
                    description: 'Healthy Pump'
                }
            ]
        };
    }

    componentDidMount() {
        this.register([
            {route: '/topic/pump/update', callback: this.reconnectPumps},
        ]);
    }

    componentWillUnmount() {
        this.state.stompClient.disconnect();
    }

    register(registrations) {
        const sock = new SockJS('/frontend');
        let stompClient = Stomp.over(sock);
        this.setState({stompClient: stompClient});
        stompClient.connect({}, function (frame) {
            console.log("Connected " + frame);
            registrations.forEach(function (registration) {
                this.state.stompClient.subscribe(registration.route, registration.callback)
            })
        });
    }

    reconnectPumps() {
        this.state.stompClient.send("/ws/reconnect", {}, JSON.stringify({pupms: this.state.pumps}))
    }

    render() {
        return (
            <ListView>
                {this.state.pumps.map(
                    (
                        {
                            actions,
                            properties,
                            title,
                            description,
                            hideCloseIcon,
                            active
                        },
                        index
                    ) => (
                        <PumpStatusItem key={index} checked={active} title={title} description={description} onClick={this.togglePump} stompClient={this.state.stompClient}/>
                    )
                )}
            </ListView>
        );
    }
}