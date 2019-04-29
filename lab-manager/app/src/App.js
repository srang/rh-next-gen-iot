import React, {Component} from 'react';
import {LabAboutMenuItem} from './LabAboutMenuItem.js'
import {VerticalNav, Icon, Dropdown, MenuItem} from 'patternfly-react';
import './css/App.css';
import pfLogo from './img/logo-alt.svg';

class App extends Component {
    render() {
        return (
            <div className="layout-pf layout-pf-fixed faux-layout">
                <VerticalNav sessionKey="storybookNoHoverDelay" hoverDelay={0}>
                    <VerticalNav.Masthead title="Next Gen Technologies at Scale" iconImg={pfLogo} >
                        <VerticalNav.IconBar>
                            <Dropdown componentClass="li" id="help">
                                <Dropdown.Toggle useAnchor className="nav-item-iconic">
                                    <Icon type="pf" name="help" />
                                </Dropdown.Toggle>
                                <Dropdown.Menu>
                                    <MenuItem>About</MenuItem>
                                    <LabAboutMenuItem bindable={this} />
                                </Dropdown.Menu>
                            </Dropdown>
                        </VerticalNav.IconBar>
                    </VerticalNav.Masthead>
                    <VerticalNav.Item title="Item 2" iconClass="fa fa-star">
                        <VerticalNav.SecondaryItem title="Item 2-B (external link)"
                                                   href="http://www.patternfly.org"/>
                        <VerticalNav.SecondaryItem title="Divider" isDivider/>
                        <VerticalNav.SecondaryItem title="Item 2-C"/>
                    </VerticalNav.Item>
                    <VerticalNav.Item title="Item 3" iconClass="fa fa-info-circle">
                        <VerticalNav.SecondaryItem title="Item 3-A"/>
                        <VerticalNav.SecondaryItem title="Divider" isDivider/>
                        <VerticalNav.SecondaryItem title="Item 3-B"/>
                        <VerticalNav.SecondaryItem title="Item 3-C"/>
                    </VerticalNav.Item>
                </VerticalNav>
                <div className="container-fluid container-cards-pf container-pf-na…">
                    <div className="row row-cards-pf">
                        <LabAboutMenuItem buttonTitle="About the Lab"/>
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
