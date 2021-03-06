package com.redhat.iot.api;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.io.Serializable;
import org.springframework.validation.annotation.Validated;
import javax.validation.Valid;
import javax.validation.constraints.*;

/**
 * ControlData
 */
@Validated
public class ControlData  implements Serializable {
  private static final long serialVersionUID = 1L;

  @JsonProperty("id")
  private Long id = null;

  @JsonProperty("pumpId")
  private Long pumpId = null;

  @JsonProperty("timestamp")
  private Long timestamp = null;

  @JsonProperty("type")
  private String type = null;

  @JsonProperty("value")
  private Float value = null;

  @JsonProperty("units")
  private String units = null;

  @JsonProperty("source")
  private String source = null;

  public ControlData id(Long id) {
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

  public ControlData pumpId(Long pumpId) {
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

  public ControlData timestamp(Long timestamp) {
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

  public ControlData type(String type) {
    this.type = type;
    return this;
  }

  /**
   * Type of input
   * @return type
  **/
  @ApiModelProperty(value = "Type of input")

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public ControlData value(Float value) {
    this.value = value;
    return this;
  }

  /**
   * Get value
   * @return value
  **/
  @ApiModelProperty(value = "")

  public Float getValue() {
    return value;
  }

  public void setValue(Float value) {
    this.value = value;
  }

  public ControlData units(String units) {
    this.units = units;
    return this;
  }

  /**
   * Get units
   * @return units
  **/
  @ApiModelProperty(value = "")

  public String getUnits() {
    return units;
  }

  public void setUnits(String units) {
    this.units = units;
  }

  public ControlData source(String source) {
    this.source = source;
    return this;
  }

  /**
   * source of control
   * @return source
  **/
  @ApiModelProperty(value = "source of control")

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ControlData controlData = (ControlData) o;
    return Objects.equals(this.id, controlData.id) &&
        Objects.equals(this.pumpId, controlData.pumpId) &&
        Objects.equals(this.timestamp, controlData.timestamp) &&
        Objects.equals(this.type, controlData.type) &&
        Objects.equals(this.value, controlData.value) &&
        Objects.equals(this.units, controlData.units) &&
        Objects.equals(this.source, controlData.source);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, pumpId, timestamp, type, value, units, source);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ControlData {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    pumpId: ").append(toIndentedString(pumpId)).append("\n");
    sb.append("    timestamp: ").append(toIndentedString(timestamp)).append("\n");
    sb.append("    type: ").append(toIndentedString(type)).append("\n");
    sb.append("    value: ").append(toIndentedString(value)).append("\n");
    sb.append("    units: ").append(toIndentedString(units)).append("\n");
    sb.append("    source: ").append(toIndentedString(source)).append("\n");
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
