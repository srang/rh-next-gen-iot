package com.redhat.iot.model;

import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.redhat.iot.api.Pump;
import com.redhat.iot.api.SensorData;
import lombok.Data;
import lombok.extern.java.Log;
import org.springframework.core.io.ClassPathResource;

import java.io.InputStream;
import java.util.LinkedList;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Data
@Log
public class Sensor {
    private Pump pump;
    private String sensorType;
    private String dataFile;
    private LinkedList<Float> dataSet;

    @java.beans.ConstructorProperties({"pump", "sensorType"})
    public Sensor(Pump pump, String sensorType) {
        this.pump = pump;
        this.sensorType = sensorType;
        // eg data/pump_1/motor-temperature.csv
        this.dataFile = String.format("data/pump_%d/%s.csv", pump.getId(), sensorType);
        loadInputData();
    }

    private void loadInputData() {
        log.info(String.format("Pump %d data loading from file %s", pump.getId(), this.dataFile));
        try {
            InputStream file = new ClassPathResource(this.dataFile).getInputStream();
            CsvSchema schema = CsvSchema.builder().addColumn(sensorType, CsvSchema.ColumnType.NUMBER).build();
            CsvMapper mapper = new CsvMapper();
            MappingIterator<Map<String, String>> readValues = mapper.readerFor(Map.class).with(schema).readValues(file);
            dataSet = readValues.readAll().stream().flatMap(stringFloatMap -> Stream.of(Float.parseFloat(stringFloatMap.get(sensorType)))).collect(Collectors.toCollection(LinkedList::new));
            log.info(String.format("Pump %d data loaded successfully from file %s; %d entries found", pump.getId(), this.dataFile, dataSet.size()));
        } catch (Exception e) {
            log.severe("Error occurred while loading dataset from file " + this.dataFile);
            throw new RuntimeException(e);
        }
    }

    // function for reading from correct dataset to provide next value for each sensor type
    public void calculateCurrentMeasure(SensorData data) {
        // read from dataset set stuff
        if (dataSet.peek() != null) {
            log.info(String.format("DataSet value: %f, timestamp: %d", dataSet.peek(), data.getTimestamp()));
            data.setValue(dataSet.poll());
        } else {
            log.warning(String.format("Dataset -- Pump-%d -- %s sensort type -- is exhausted", pump.getId(), sensorType));
            log.info("Reloading data");
            loadInputData();
            log.info(String.format("DataSet value: %f, timestamp: %d", dataSet.peek(), data.getTimestamp()));
            data.setValue(dataSet.poll());
        }
    }
}
