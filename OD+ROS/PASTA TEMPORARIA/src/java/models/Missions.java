package models;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Scanner;
import java.util.concurrent.Executors;
import conexao.MysqlDB;
import conexao.MysqlQuery;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.concurrent.TimeUnit;
/**
 *
 * @author Matheus Vinicius G de Godoi
 */
public class Missions {
    private int userId;
    private String missionPath;
    private String missionName;

    public Missions(){
        //Construtor vazio      
    }
    
    public Missions(int id, String missao, String nome){
        //Construtor com os dados da missão preenchido
        this.userId = id;
        this.missionPath = missao;
        this.missionName = nome;
    }

    public int getUserId() {
        return userId;
    }

    public String getMissionPath() {
        return missionPath;
    }

    public String getMissionName() {
        return missionName;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setMissionPath(String missionPath) {
        this.missionPath = missionPath;
    }

    public void setMissionName(String missionName) {
        this.missionName = missionName;
    }
    
    public List<Missions> visualizar(int id_user) {
        List<Missions> listaMissoes = new ArrayList<Missions>();

        try {
            MysqlDB banco = new MysqlDB();
            banco.connect();
            PreparedStatement ps = null;
            ResultSet rs = null;
            String sql = null;

            ps = banco.conn.prepareStatement("SELECT * FROM missions WHERE user_id_user = " + id_user);
            rs = ps.executeQuery();

            if (!rs.next()) {
                // pensar ainda no retorno
                System.out.println("Não foi encontrado missões");
            } else {
                rs.beforeFirst();
                while (rs.next()) {
                    Missions m = new Missions();
                    m.setUserId(rs.getInt(1));
                    m.setMissionName(rs.getString(2));
                    m.setMissionPath(rs.getString(3));
                    listaMissoes.add(m);
                }
            }
        } catch (SQLException exception) {
            System.out.println("Impossivel visualizar Missoes: " + exception);
        }
        return listaMissoes;
    }
}