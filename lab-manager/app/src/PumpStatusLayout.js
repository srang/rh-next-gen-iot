import React, {Component} from 'react';
import {CardGrid, Card, CardTitle, CardBody, CardFooter, CardDropdownButton, MenuItem, CardLink, Icon} from 'patternfly-react';
import {PumpListView} from "./PumpListView";

export class PumpStatusLayout extends Component {
    render() {
        return (
            <CardGrid>
                <CardGrid.Row style={{marginBottom: '20px', marginTop: '40px'}}>
                    <CardGrid.Col xs={12} md={12}>
                        <Card>
                            <CardTitle>Card Title</CardTitle>
                            <CardBody>
                                <PumpListView />
                            </CardBody>
                            <CardFooter>
                                <CardDropdownButton id="cardDropdownButton1" title="Last 30 Days">
                                    <MenuItem eventKey="1" active>
                                        Last 30 Days
                                    </MenuItem>
                                    <MenuItem eventKey="2">Last 60 Days</MenuItem>
                                    <MenuItem eventKey="3">Last 90 Days</MenuItem>
                                </CardDropdownButton>
                                <CardLink disabled icon={<Icon type="pf" name="flag"/>}>
                                    View CPU Events
                                </CardLink>
                            </CardFooter>
                        </Card>
                    </CardGrid.Col>
                </CardGrid.Row>
            </CardGrid>

        );
    }
}


