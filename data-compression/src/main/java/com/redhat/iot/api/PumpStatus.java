/*
 * Pump Monitor
 * No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)
 *
 * OpenAPI spec version: 1.0.0
 * 
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 */

package com.redhat.iot.api;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.io.Serializable;
import com.fasterxml.jackson.dataformat.xml.annotation.*;
import javax.xml.bind.annotation.*;

/**
 * PumpStatus
 */

@XmlRootElement(name = "PumpStatus")
@XmlAccessorType(XmlAccessType.FIELD)
@JacksonXmlRootElement(localName = "PumpStatus")public class PumpStatus implements Serializable {
  private static final long serialVersionUID = 1L;

  @JsonProperty("id")
  @JacksonXmlProperty(localName = "id")
  @XmlElement(name="id")

  private Long id = null;

  @JsonProperty("pumpId")
  @JacksonXmlProperty(localName = "pumpId")
  @XmlElement(name="pumpId")

  private Long pumpId = null;

  @JsonProperty("timestamp")
  @JacksonXmlProperty(localName = "timestamp")
  @XmlElement(name="timestamp")

  private Long timestamp = null;

  @JsonProperty("status")
  @JacksonXmlProperty(localName = "status")
  @XmlElement(name="status")

  private String status = null;
  public PumpStatus id(Long id) {
    this.id = id;
    return this;
  }

  

  /**
  * Get id
  * @return id
  **/
  @ApiModelProperty(value = "")
  public Long getId() {
    return id;
  }
  public void setId(Long id) {
    this.id = id;
  }
  public PumpStatus pumpId(Long pumpId) {
    this.pumpId = pumpId;
    return this;
  }

  

  /**
  * Get pumpId
  * @return pumpId
  **/
  @ApiModelProperty(value = "")
  public Long getPumpId() {
    return pumpId;
  }
  public void setPumpId(Long pumpId) {
    this.pumpId = pumpId;
  }
  public PumpStatus timestamp(Long timestamp) {
    this.timestamp = timestamp;
    return this;
  }

  

  /**
  * Get timestamp
  * @return timestamp
  **/
  @ApiModelProperty(value = "")
  public Long getTimestamp() {
    return timestamp;
  }
  public void setTimestamp(Long timestamp) {
    this.timestamp = timestamp;
  }
  public PumpStatus status(String status) {
    this.status = status;
    return this;
  }

  

  /**
  * Get status
  * @return status
  **/
  @ApiModelProperty(value = "")
  public String getStatus() {
    return status;
  }
  public void setStatus(String status) {
    this.status = status;
  }
  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    PumpStatus pumpStatus = (PumpStatus) o;
    return Objects.equals(this.id, pumpStatus.id) &&
        Objects.equals(this.pumpId, pumpStatus.pumpId) &&
        Objects.equals(this.timestamp, pumpStatus.timestamp) &&
        Objects.equals(this.status, pumpStatus.status);
  }

  @Override
  public int hashCode() {
    return java.util.Objects.hash(id, pumpId, timestamp, status);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class PumpStatus {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    pumpId: ").append(toIndentedString(pumpId)).append("\n");
    sb.append("    timestamp: ").append(toIndentedString(timestamp)).append("\n");
    sb.append("    status: ").append(toIndentedString(status)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(java.lang.Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }

}
