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
public class Rosod {
    private String porta_conexao;
    private Process processoPx4;
    private Process processoRoslaunch;
    private Process processoQGround;
    private Process carregaMissao;
    private Process iniciaMissao;
    private Process controleDrone;

    public Rosod(){
        //Construtor vazio
    }
    
    public Rosod(String porta){
        //Construtor com o campo de porta preenchido
        this.porta_conexao = porta;
    }
    
    
    //Gets e sets
    public void setPorta(String porta){
        this.porta_conexao = porta;
    }
    
    public String getPorta(){
        return this.porta_conexao;
    }
    
    
    //================ Métodos para voo simulado ================//
    public void conectaDroneSimulado() throws IOException, InterruptedException{
        //Outro caminho para o script pode ser usado
        this.processoPx4 = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptConectarPx4.sh");
        this.processoRoslaunch = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptConectarRoslaunch.sh ");
        this.processoQGround = Runtime.getRuntime().exec("/home/claudio/Scripts/QGroundControl.AppImage ");
    }
    
    public void carregaMissaoSimulado(String caminho) throws IOException{
        System.out.println("CarregaMissaoSimulado: " + caminho);
        this.carregaMissao = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptUploadMissao.sh " + caminho);
    }
    
    //Função para iniciar a missão
    public void iniciaMissaoSimulado() throws IOException{
        this.iniciaMissao = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptIniciaMissao.sh");
    }
    
    public void controleDroneSimulado(String tipo) throws IOException{
        switch(tipo){
            case "arm_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptArm.sh");
            break;
            case "takeoff_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptTakeoff.sh");                
            break;
            case "land_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptLand.sh");
            break;
            case "auto_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptAuto.sh");
            break;
            case "loiter_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptLoiter.sh");
            break;
            default:
                System.out.println("NÃO ENCONTRADO CONTROLE SIMULADO: " + tipo);
            break;
        }
    }
    
    //Função para matar o processo
    public void desconectaDroneSimulado(){
        //TODO
    }
    
    //================ Métodos para voo real ================//
    //Função para conectar
    public void conectaDrone(String porta) throws IOException, InterruptedException{
        //Outro caminho para o script pode ser usado
        this.processoRoslaunch = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptConectarRoslaunchReal.sh " + porta);
        this.processoQGround = Runtime.getRuntime().exec("/home/claudio/Scripts/QGroundControl.AppImage ");
    }
    
    //Função para iniciar a missão
    public void iniciaMissao() throws IOException{
        this.iniciaMissao = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptIniciaMissaoReal.sh");
    }
    
    public void carregaMissao(String caminho) throws IOException{
        System.out.println("CarregaMissaoReal: " + caminho);
        this.carregaMissao = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptUploadMissao.sh " + caminho);
    }
    
    public void controleDrone(String tipo) throws IOException{
        switch(tipo){
            case "arm_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptArm.sh");
            break;
            case "takeoff_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptTakeoff.sh");                
            break;
            case "land_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptLand.sh");
            break;
            case "auto_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptAuto.sh");
            break;
            case "loiter_rosod":
                this.controleDrone = Runtime.getRuntime().exec("/home/claudio/Scripts/scriptLoiter.sh");
            break;
            default:
                System.out.println("NÃO ENCONTRADO CONTROLE REAL: " + tipo);
            break;
        }
    }
    //Função para matar o processo
    public void desconectaDrone(){
        //TODO
    }
}
