package com.apkdecompiler;

import jadx.api.JadxArgs;
import jadx.api.JadxDecompiler;
import java.io.File;

public class ApkDecompiler {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java -jar apkdecompiler.jar <input.apk> <output_folder>");
            System.exit(1);
        }

        String inputFile = args[0];
        String outputFolder = args[1];

        JadxArgs jadxArgs = new JadxArgs();
        jadxArgs.setInputFile(new File(inputFile));
        jadxArgs.setOutDir(new File(outputFolder));

        try (JadxDecompiler jadx = new JadxDecompiler(jadxArgs)) {
            jadx.load();
            System.out.println("Decompiling " + inputFile + " to " + outputFolder);
            jadx.save();
            System.out.println("Decompilation completed successfully!");
        } catch (Exception e) {
            System.err.println("Error during decompilation: " + e.getMessage());
            e.printStackTrace();
        }
    }
}