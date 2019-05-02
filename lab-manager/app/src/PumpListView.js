import React, {Component} from 'react';
import {ListView, Row, Col} from 'patternfly-react';

export class PumpListView extends Component {
    constructor() {
        super();
        this.printStuff = this.printStuff.bind(this)
        this.state = {
            pumps: [],
            listItems: [
                {
                    title: 'Item 1',
                    description: 'This is Item 1 description',
                    properties: {hosts: 3, clusters: 1, nodes: 7, images: 4},
                    expandedContentText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    compoundExpandText: {
                        hosts: "Text describing Item 1's hosts",
                        clusters: "Text describing Item 1's clusters",
                        nodes: "Text describing Item 1's nodes",
                        images: "Text describing Item 1's images"
                    }
                },
                {
                    title: 'Item 2',
                    description: 'This is Item 2 description',
                    properties: {hosts: 2, clusters: 1, nodes: 11, images: 8},
                    expandedContentText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    compoundExpandText: {
                        hosts: "Text describing Item 2's hosts",
                        clusters: "Text describing Item 2's clusters",
                        nodes: "Text describing Item 2's nodes",
                        images: "Text describing Item 2's images"
                    }
                },
                {
                    title: 'Item 3',
                    description: 'This is Item 3 description',
                    properties: {hosts: 4, clusters: 2, nodes: 9, images: 8},
                    expandedContentText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    compoundExpandText: {
                        hosts: "Text describing Item 3's hosts",
                        clusters: "Text describing Item 3's clusters",
                        nodes: "Text describing Item 3's nodes",
                        images: "Text describing Item 3's images"
                    }
                },
                {
                    description: 'This is Item without heading',
                    expandedContentText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    compoundExpandText: {
                        hosts: "Text describing Item 4's hosts",
                        clusters: "Text describing Item 4's clusters",
                        nodes: "Text describing Item 4's nodes",
                        images: "Text describing Item 4's images"
                    }
                },
                {
                    properties: {hosts: 4, clusters: 2, nodes: 9, images: 8},
                    expandedContentText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    compoundExpandText: {
                        hosts: "Text describing Item 5's hosts",
                        clusters: "Text describing Item 5's clusters",
                        nodes: "Text describing Item 5's nodes",
                        images: "Text describing Item 5's images"
                    }
                },
                {
                    title: 'Item without description or close icon',
                    expandedContentText: 'There is no close `x` on the right of this box.',
                    hideCloseIcon: true,
                    compoundExpandText: {
                        hosts: "Text describing Item 6's hosts",
                        clusters: "Text describing Item 6's clusters",
                        nodes: "Text describing Item 6's nodes",
                        images: "Text describing Item 6's images"
                    }
                }
            ]
        };
    }
    componentDidMount() {
        console.log("here1");
        this.register([
            {route: '/user1', callback: this.printStuff}
        ]);
    }
    register(registrations) {
        const socket = 'ws://localhost:9292/ws/sensordata';
        const ws = new WebSocket(socket);
        ws.onmessage = function (event) {
            console.log(event.data)
        }
    }

    printStuff(data) {
        console.log(data)
    }

    render() {
        return (
                <ListView>
                    {this.state.listItems.map(
                        (
                            {
                                actions,
                                properties,
                                title,
                                description,
                                expandedContentText,
                                hideCloseIcon
                            },
                            index
                        ) => (
                            <ListView.Item
                                key={index}
                                checkboxInput={<input type="checkbox"/>}
                                leftContent={<ListView.Icon name="plane"/>}
                                heading={title}
                                description={description}
                                stacked={true}
                                hideCloseIcon={false}
                            >
                                <Row>
                                    <Col sm={11}>{expandedContentText}</Col>
                                </Row>
                            </ListView.Item>
                        )
                    )}
                </ListView>
        );
    }
}