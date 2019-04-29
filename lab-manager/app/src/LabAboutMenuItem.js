import React, {Component} from 'react';
import summit from './img/summit.svg';
import './css/App.css';
import { Dropdown, AboutModal, MenuItem } from 'patternfly-react';

export class LabAboutMenuItem extends Component {
    constructor() {
        super();
        this.state = { showModal: false };
        this.open = this.open.bind(this.props.bindable);
        this.close = this.close.bind(this.props.bindable);
    }
    open() {
        this.setState({ showModal: true });
    }
    close() {
        this.setState({ showModal: false });
    }
    render() {
        return (
            <div>
                <AboutModal
                    show={this.state.showModal}
                    onHide={this.close}
                    productTitle="Next Gen Technologies at Scale"
                    logo={summit}
                    altLogo="Red Hat Summit 2019 Logo"
                    trademarkText="github.com/ablock/something"
                >
                    <AboutModal.Versions>
                        <AboutModal.VersionItem label="Presenter" versionText="Sam Rang" />
                        <AboutModal.VersionItem label="Presenter" versionText="Andrew Block" />
                        <AboutModal.VersionItem label="Presenter" versionText="Ishu Verma" />
                        <AboutModal.VersionItem label="Presenter" versionText="Hugo Guerrero Olivares" />
                        <AboutModal.VersionItem label="Presenter" versionText="Christina Lin" />
                    </AboutModal.Versions>
                </AboutModal>

            </div>
        );
    }
}

