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
 * SensorData
 */
@Validated
public class SensorData  implements Serializable {
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

  public SensorData id(Long id) {
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

  public SensorData pumpId(Long pumpId) {
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

  public SensorData timestamp(Long timestamp) {
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

  public SensorData type(String type) {
    this.type = type;
    return this;
  }

  /**
   * Type of measurement
   * @return type
  **/
  @ApiModelProperty(value = "Type of measurement")

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public SensorData value(Float value) {
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

  public SensorData units(String units) {
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


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    SensorData sensorData = (SensorData) o;
    return Objects.equals(this.id, sensorData.id) &&
        Objects.equals(this.pumpId, sensorData.pumpId) &&
        Objects.equals(this.timestamp, sensorData.timestamp) &&
        Objects.equals(this.type, sensorData.type) &&
        Objects.equals(this.value, sensorData.value) &&
        Objects.equals(this.units, sensorData.units);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, pumpId, timestamp, type, value, units);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class SensorData {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    pumpId: ").append(toIndentedString(pumpId)).append("\n");
    sb.append("    timestamp: ").append(toIndentedString(timestamp)).append("\n");
    sb.append("    type: ").append(toIndentedString(type)).append("\n");
    sb.append("    value: ").append(toIndentedString(value)).append("\n");
    sb.append("    units: ").append(toIndentedString(units)).append("\n");
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
