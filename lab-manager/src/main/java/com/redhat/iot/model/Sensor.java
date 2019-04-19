package com.redhat.iot.model;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.redhat.iot.api.Pump;
import com.redhat.iot.api.SensorData;
import lombok.Data;
import lombok.extern.java.Log;
import org.springframework.core.io.ClassPathResource;

import java.io.File;
import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Data
@Log
public class Sensor {
    private Pump pump;
    private String sensorType;
    private LinkedList<Float> dataSet;

    @java.beans.ConstructorProperties({"pump", "sensorType"})
    public Sensor(Pump pump, String sensorType) {
        this.pump = pump;
        this.sensorType = sensorType;
        // eg data/pump_1/motor-temperature.csv
        String fileName = String.format("data/pump_%d/%s.csv", pump.getId(), sensorType);
        try {
            InputStream file = new ClassPathResource(fileName).getInputStream();
            CsvSchema schema = CsvSchema.builder().addColumn(sensorType, CsvSchema.ColumnType.NUMBER).build();
            CsvMapper mapper = new CsvMapper();
            MappingIterator<Map<String, Float>> readValues = mapper.readerFor(Map.class).with(schema).readValues(file);
            dataSet = new LinkedList<>(readValues.readAll().stream().flatMap(stringFloatMap -> Stream.of(stringFloatMap.get(sensorType))).collect(Collectors.toList()));
        } catch (Exception e) {
            log.severe("Error occurred while loading dataset from file " + fileName);
            throw new RuntimeException(e);
        }
    }

    // function for reading from correct dataset to provide next value for each sensor type
    public void calculateCurrentMeasure(SensorData data) {
        // read from dataset set stuff
        if (dataSet.peek() != null) {
            data.setValue(dataSet.poll());
        } else {
            log.severe(String.format("Dataset -- Pump-%d -- %s sensort type -- is exhausted", pump.getId(), sensorType));
            throw new RuntimeException("Out of data");
        }
    }
}
