import React, {Component} from 'react';
import logo from './img/redhat_reverse.png';
import { VerticalNav } from 'patternfly-react';
import {LabAboutModal} from './LabAboutModal.js'
import './css/App.css';

const {Masthead, Brand, IconBar, Item, SecondaryItem, TertiaryItem} = VerticalNav;

class App extends Component {
    render() {
        return (
            <div className="layout-pf layout-pf-fixed faux-layout">
                <VerticalNav sessionKey="storybookNoHoverDelay" hoverDelay={0} showBadges>
                    <VerticalNav.Masthead title="Patternfly React"/>
                    <VerticalNav.Item title="Item 2" iconClass="fa fa-star">
                        <VerticalNav.SecondaryItem title="Item 2-B (external link)"
                                                   href="http://www.patternfly.org"/>
                        <VerticalNav.SecondaryItem title="Divider" isDivider/>
                        <VerticalNav.SecondaryItem title="Item 2-C"/>
                    </VerticalNav.Item>
                    <VerticalNav.Item title="Item 3" iconClass="fa fa-info-circle">
                        <VerticalNav.SecondaryItem title="Item 3-A"/>
                        <VerticalNav.SecondaryItem title="Divider" isDivider/>
                        <VerticalNav.SecondaryItem title="Item 3-B">
                            <VerticalNav.TertiaryItem title="Item 3-B-i"/>
                            <VerticalNav.TertiaryItem title="Item 3-B-ii"/>
                            <VerticalNav.TertiaryItem title="Item 3-B-iii"/>
                        </VerticalNav.SecondaryItem>
                        <VerticalNav.SecondaryItem title="Item 3-C"/>
                    </VerticalNav.Item>
                </VerticalNav>
                <div className="container-fluid container-cards-pf container-pf-na…">
                    <div className="row row-cards-pf">
                        <LabAboutModal buttonTitle="About the Lab" />
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
