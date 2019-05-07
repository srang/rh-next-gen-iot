import React, {Component} from 'react';
import {ListView, Table, Row, Col} from 'patternfly-react';
import * as SockJS from 'sockjs-client'
import {Stomp} from '@stomp/stompjs'

export class PumpListView extends Component {
    constructor() {
        super();
        // this.uniquePumps = this.uniquePumps.bind(this);
        this.tabulateSensorData = this.tabulateSensorData.bind(this);
        this.pumpStatus = this.pumpStatus.bind(this);
        this.state = {
            stompClient: {},
            showResults: true,
            pumps: []
        };
    }

    componentDidMount() {
        this.register([
            {route: '/topic/sensordata', callback: this.tabulateSensorData},
            {route: '/topic/pumpstatus', callback: this.pumpStatus}
        ]);
    }

    register(registrations) {
        const sock = new SockJS('/frontend');
        let stompClient = Stomp.over(sock);
        this.setState({stompClient: stompClient});
        stompClient.connect({}, function (frame) {
            console.log("Connected " + frame);
            registrations.forEach(function (registration) {
                stompClient.subscribe(registration.route, registration.callback)
            })
        });
    }

    pumpStatus(data) {
        let message = JSON.parse(data.body);
        let pumps = this.state.pumps;
        for (var property in message) {
            let decision = message[property];
            let statusData = {timestamp: decision.timestamp, pumpId: decision.pumpId, type: decision.type, value: decision.value};
            switch(decision.result) {
                case "0":
                    statusData.status = "Healthy";
                    break;
                case "1":
                    statusData.status = "Warning";
                    break;
                case "2":
                    statusData.status = "Error";
                    break;
            }
            pumps[decision.pumpId].statusData.push(statusData)
        }
    }

    tabulateSensorData(data) {
        let message = JSON.parse(data.body);
        let pumps = this.state.pumps;
        if (!pumps[message.pumpId]) {
            pumps[message.pumpId] =
                {
                    title: 'ESP ' + message.pumpId,
                    description: 'Electronic Submersible Pump ' + message.pumpId,
                    sensorData: [],
                    statusData: []
                };
            console.log("Added pump: " + pumps[message.pumpId].title)
        }
        pumps[message.pumpId].sensorData.push(message);
        this.setState({pumps: pumps});
    }

    componentWillUnmount() {
        clearInterval(this.timerID);
        this.state.stompClient.disconnect();
    }

    render() {
        const headerFormat = value => <Table.Heading>{value}</Table.Heading>;
        const cellFormat = value => <Table.Cell>{value}</Table.Cell>;
        let statusColumns = [
            {
                header: {
                    label: 'Unix Timestamp',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'timestamp'
            },
            {
                header: {
                    label: 'Pump ID',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'pumpId'
            },
            {
                header: {
                    label: 'Data Type',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'type'
            },
            {
                header: {
                    label: 'Data Evaluation',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'status'
            },
            {
                header: {
                    label: 'Data Value',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'value'
            }
        ];
        let sensorColumns = [
            {
                header: {
                    label: 'Unix Timestamp',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'timestamp'
            },
            {
                header: {
                    label: 'Pump ID',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'pumpId'
            },
            {
                header: {
                    label: 'Data Type',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'type'
            },
            {
                header: {
                    label: 'Data Value',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'value'
            },
            {
                header: {
                    label: 'Data Units',
                    formatters: [headerFormat]
                },
                cell: {
                    formatters: [cellFormat]
                },
                property: 'units'
            }
        ];
        return (
            <ListView>
                {this.state.pumps.map(
                    (
                        {
                            actions,
                            properties,
                            title,
                            description,
                            sensorData,
                            statusData,
                            hideCloseIcon
                        },
                        index
                    ) => (
                        <ListView.Item
                            key={index}
                            leftContent={<ListView.Icon name="wifi"/>}
                            heading={title}
                            description={description}
                            stacked={true}
                            hideCloseIcon={true}
                        >
                            <Row>
                                <Col sm={11}>
                                    <div>
                                        <h3>Status Data</h3>
                                        <Table.PfProvider columns={statusColumns}>
                                            <Table.Header/>
                                            <Table.Body rows={statusData} rowKey="timestamp"/>
                                        </Table.PfProvider>
                                        <h3>Sensor Data</h3>
                                        <Table.PfProvider columns={sensorColumns}>
                                            <Table.Header/>
                                            <Table.Body rows={sensorData} rowKey="timestamp"/>
                                        </Table.PfProvider>
                                    </div>
                                </Col>
                            </Row>
                        </ListView.Item>
                    )
                )}
            </ListView>
        );
    }
}