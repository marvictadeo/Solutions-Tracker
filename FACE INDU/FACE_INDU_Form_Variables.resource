*** Settings ***
Documentation    Variables for FACE INDU Form


*** Variables ***
${MAX_TIMEOUT}                                   30s
${BTN_CREATE}                      //div[@class="card-button__wrapper"]//div[text()='Create']
${DATA_TABLE}                      //div[@class="datatable-body-cell-label"]/a[text()=" Internal QA Test GRAP"]
${JPG_IMAGE_SAMPLE}                ${CURDIR}${/}Jpg_Img_Photo.jpg

# Excel Data
${MASTER_DATA}                          ${CURDIR}${/}..\\Master_File.xlsx

# Common Fields

${DDL_DIVISION}                              //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                           //select[@formcontrolname="subDivision"]
${DDL_SC}                                    //select[@formcontrolname="serviceClassification"]
${DDL_ST}                                    //select[@formcontrolname="serviceType"]
${DDL_SR}                                    //select[@formcontrolname="serviceRequirement"]
${TXT_SUBJECT}                               //input[@formcontrolname="subject"]
${TXT_DESCRIPTION}                           //textarea[@formcontrolname="description"]
${DDL_PRIORITY}                              //select[@formcontrolname="priority"]
${DDL_CUSTOMER_DIVISION}                     //select[@formcontrolname="senderDivision"]
${DDL_CUSTOMER_SUBDIVISION}                  //select[@formcontrolname="senderSubDivision"]
${DDL_CUSTOMER_LOCATION}                     //select[@formcontrolname="senderLocation"]

# DDL Value Lists
@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_LOCATION}                      ET-VG1 (Empower Tribe VG1 Ltd.)
...                                   ET-VG2 (Empower Tribe VG2 Ltd.)
...                                   ET-VG3 (Empower Tribe VG3 Ltd.)
...                                   ET1 (Empower Trust)
...                                   MT-BM1 (Music Tribe Global Services Ltd.)
...                                   MT-BM2 (Music Tribe Commercial BM Ltd.)
...                                   MT-CA1 (Music Tribe Brands CA Ltd.)
...                                   MT-CN1 (Zhongshan Eurotec Electronics Limited)
...                                   MT-CN2 (Zhongshan Eurotec Electronics Limited – Shenzhen Branch)
...                                   MT-CN3 (Zhongshan Behringer Electronics Ltd.)
...                                   MT-DE1 (Music Tribe Brands DE GmbH)
...                                   MT-DK1 (Music Tribe Brands DK A/S)
...                                   MT-DK2 (Music Tribe Innovation DK A/S)
...                                   MT-IN1 (Music Tribe Innovation Private Limited)
...                                   MT-MU1 (Music Tribe Manufacturing Ltd.)
...                                   MT-MY1 (Music Tribe Commercial MY Sdn Bhd)
...                                   MT-MY2 (Music Tribe Hi-Tech Electronics Sdn Bhd)
...                                   MT-PH1 (Music Group Commercial BM Ltd. ROHQ)
...                                   MT-PH2 (Music Tribe Services PH Corp)
...                                   MT-PH3 (Music Group Macao Commercial Offshore Limited ROHQ - Philippines)
...                                   MT-PH4 (Music Group Commercial PH Inc.)
...                                   MT-PH5 (Behringer Holdings (Pte) Ltd. ROHQ)
...                                   MT-PH6 (Music Global Shared Services Inc.)
...                                   MT-SE1 (Music Tribe Brands Sweden AB)
...                                   MT-UK1 (Music Tribe Brands UK Ltd.)
...                                   MT-UK4 (Aston Microphones Limited)
...                                   MT-US1 (Music Tribe Commercial NV Inc.)
...                                   MT-VG1 (Music Tribe VG1 Ltd.)

@{LIST_BRANDS}                        Music Tribe    Aston Microphones    Midas    Lab Gruppen    Tannoy
...                                   Turbosound    TC Electronic    TC Helicon
...                                   Behringer    Klark Teknik    Bugera    Lake    Coolaudio

@{LIST_FACE_DIVISION}                 AVAI    BRAN    BRAN COMM    COMP    CUST AVAI    CUST SUPP
...                                   DIGI  FACE     HEAR      HOSP
...                                   INNO      LEGA      QUAL      RESE
...                                   STRA      TRAN      TREA      VALU      VISI

@{LIST_AVAI_SUB_DIV}                  AVAI      AVAI CONT      AVAI DEMA      AVAI INVE      AVAI LEAN
...                                   AVAI LOGI      AVAI PMC WARE      AVAI PROD
@{LIST_BRAN_SUB_DIV}                  AM BRAN CATE    BE BRAN CATE     BX BRAN CATE
...                                   LG BRAN CATE    MI BRAN CATE     MT BRAN CATE      TA BRAN CATE
...                                   TE BRAN CATE    TS BRAN CATE
@{LIST_BRAN COMM_SUB_DIV}             BRAN COMM    BRAN COMM CONT    BRAN COMM EVEN
...                                   BRAN COMM RELA      BRAN COMM SOCI
@{LIST_COMP_SUB_DIV}                  COMP    COMP GRC    COMP IA
@{LIST_CUST AVAI_SUB_DIV}             CUST AVAI    CUST AVAI CDS    CUST AVAI COMM
...                                   CUST AVAI DEMA    CUST AVAI ENTE
@{LIST_CUST SUPP_SUB_DIV}             CUST QUAL    UST SUPP SERV    CUST SUPP SOLU    CUST SUPP TECH
@{LIST_DIGI_SUB_DIV}                  DIGI      DIGI APPL      DIGI INFR
@{LIST_FACE_SUB_DIV}                  FACE      FACE COPY      FACE GRAP      FACE INDU
...                                   FACE MEDI      FACE PRIN      FACE QUAL    FACE REND
...                                   FACE STYL      FACE TECH      FACE UX      FACE VIDE
...                                   FACE WEB      PERF FACE BA
@{LIST_HEAR_SUB_DIV}                  HEAR      HEAR ACQU      HEAR DEVE      HEAR REWA
@{LIST_HOSP_SUB_DIV}                  HOSP      HOSP ACCO      HOSP EHS      HOSP FACI      HOSP TRAV
@{LIST_INNO_SUB_DIV}                  INNO      INNO ACOU      INNO COMP      INNO MECH
...                                   INNO PCB    INNO SOFT      INNO SYST
@{LIST_LEGA_SUB_DIV}                  LEGA COMM      LEGA GOVE      LEGA HEAR      LEGA IP
@{LIST_QUAL_SUB_DIV}                  QUAL
@{LIST_RESE_SUB_DIV}                  RESE      RESE AI      RESE DATA      RESE PLAT
@{LIST_STRA_SUB_DIV}                  STRA PROD
@{LIST_TRAN_SUB_DIV}                  TRAN    TRAN BRAN    TRAN SHAR
@{LIST_TREA_SUB_DIV}                  TREA INVE    TREA OTC    TREA PTP    TREA RTR    TREA TAX
@{LIST_VALU_SUB_DIV}                  Customer Feedback    VALU    VALU DM    VALU IDM
@{LIST_VISI_SUB_DIV}                  VISI STRA

@{LIST_DEVELOPMENT_CLASSIFICATION}    In-house    External JDM    External OEM
@{LIST_PDI_TYPE}                      PDI 0    PDI 1
@{LIST_MATERIAL_CATEGORY_L1}          Amplifiers    Audio Interfaces    Cables and Connectors    Commercial Amplifiers
...                                   Controllers    DI Boxes    DJ Equipment    Drums and Percussion    Effects and Signal Processors
...                                   Guitar and Bass    Headphones    Intercoms    Keys    Lighting    Loudspeakers    Microphones
...                                   MIDI Equipment    Mixers    Mixing Consoles    Personal Monitors    Power Amplifiers    Recording Bundles
...                                   Signal Processors    Software    Stands and Accessories    Studio Controllers and Meters    Studio Recording
...                                   Synthesizers and Keyboards    System Configuration Tools    Voice Processors
@{LIST_AMPLIFIERS_MATERIAL_CATEGORY_L2}                                Amplifier Racks    Power Amplifiers    Power Amplifiers with DSP
@{LIST_AUDIO INTERFACES_MATERIAL_CATEGORY_L2}                          ADAT Audio Interfaces    Firewire Audio Interfaces    Mobile Device Interfaces
...                                                                    Online Broadcast Interfaces    Patch Bays    USB Audio Interfaces
@{LIST_CABLES AND CONNECTORS_MATERIAL_CATEGORY_L2}                     Adapters    Audio Cables    Bulk Cables    Cable Testers    Computer Cables
...                                                                    Connectors    DMX Cables    Instrument Cables    Loudspeaker Cables    Microphone Cables
...                                                                    MIDI Cables    Multicore Cables    Network Cables    Patch Cables
@{LIST_COMMERCIAL AMPLIFIERS_MATERIAL_CATEGORY_L2}                     Accessories for Commercial Amplifiers    Commercial Amplifiers with DSP    Commercial Rack Mixers
@{LIST_CONTROLLERS_MATERIAL_CATEGORY_L2}                               Bluetooth Controllers    DAW Applications    DAW Controllers
@{LIST_DI BOXES_MATERIAL_CATEGORY_L2}                                  Active DI Boxes    Network DI Boxes    Passive DI Boxes    Passive Signal Splitters    Wireless DI Boxes
@{LIST_DJ EQUIPMENT_MATERIAL_CATEGORY_L2}                              DJ Controllers    DJ Mixers    DJ Systems    Phono Preamplifiers
@{LIST_DRUMS AND PERCUSSION_MATERIAL_CATEGORY_L2}                      Drum Machines    Drum Machines and Samplers    Electronic Drum Kits
@{LIST_EFFECTS AND SIGNAL PROCESSORS_MATERIAL_CATEGORY_L2}             Accessories for Signal Processors    Audio and Effects Plug-Ins    Audio Converters    Compressors/Limiters
...                                                                    Configuration Applications    Crossovers    Delays/Reverbs    Equalizers    Feedback Controllers
...                                                                    I/O Interfaces    Loudness Management Processors    Loudspeaker Management Systems    Memory Bank
...                                                                    Merchandise    Multi-Effects Processors    Networked DSP    Networked Video    Rack Frames
...                                                                    Software Licenses    Solid State Recorders    Sound Enhancers    Video Switcher    Vocal Effects
@{LIST_GUITAR AND BASS_MATERIAL_CATEGORY_L2}                           Acoustic Instrument Amplifiers    Bass Amplifiers    Bass Guitar Packs    Effects and Pedals
...                                                                    Guitar Amplifiers    Guitar and Bass Wireless    Guitar Packs    Tuners    USB Guitars
@{LIST_HEADPHONES_MATERIAL_CATEGORY_L2}                                Bluetooth Headphones    Computer Headsets    DJ Headphones    Headphone Amplifiers
...                                                                    Studio Headphones    Wireless In-Ear Monitors
@{LIST_INTERCOMS_MATERIAL_CATEGORY_L2}                                 Digital Comms/Cue System    Intercom Configuration Applications    Intercom Headsets
...                                                                    Intercom Microphones    Research Projects
@{LIST_KEYS_MATERIAL_CATEGORY_L2}                                      Synthesizers
@{LIST_LIGHTING_MATERIAL_CATEGORY_L2}                                  Accessories for Lighting    DMX Lighting Controllers    Effect Lighting    Effect Machines    Lamps
...                                                                    Moving Heads    Power Distributors    Theater Lighting
@{LIST_LOUDSPEAKERS_MATERIAL_CATEGORY_L2}                              Bluetooth Speakers    Ceiling Speakers    Column Speakers    HiFi Speakers    High-End Speakers
...                                                                    Home Theatre Systems    Horn Speakers    In-Wall Speakers    Line Arrays    Loudspeaker Bundles
...                                                                    Loudspeaker Components    Merchandise    Pendant Speakers    Point Source Speakers    Portable PA Speakers
...                                                                    Research Projects    Rock Speakers    Stage Monitors    Studio Monitors    Subwoofers    Surface Mount Speakers
@{LIST_MICROPHONES_MATERIAL_CATEGORY_L2}                               Accessories for Microphones    Gooseneck Microphones    Handheld Microphones    Instrument Microphones
...                                                                    Large Diaphragm Microphones    Lavalier Microphones    Measurement Microphones    Microphone Preamplifiers
...                                                                    Vocal Microphones    Wireless Microphones
@{LIST_MIDI EQUIPMENT_MATERIAL_CATEGORY_L2}                            MIDI Controllers    MIDI Interfaces    Research Projects
@{LIST_MIXERS_MATERIAL_CATEGORY_L2}                                    Analog Mixers    Analog Rack Mixers    Digital Mixers    Digital Rack Mixers    Digital Stagebox Mixers
...                                                                    I/O Interfaces    Merchandise    Software
@{LIST_MIXING CONSOLES_MATERIAL_CATEGORY_L2}                           Digital Mixers
@{LIST_PERSONAL MONITORS_MATERIAL_CATEGORY_L2}                         Research Projects    Wired In-Ear Monitoring Components
@{LIST_POWER AMPLIFIERS_MATERIAL_CATEGORY_L2}                          Accessories for Power Amplifiers    Amplifier Modules with DSP    Power Amplifiers    Power Amplifiers with DSP
...                                                                    Power Amplifiers with DSP and Network    Power Amplifiers with Network
@{LIST_RECORDING BUNDLES_MATERIAL_CATEGORY_L2}                         Firewire Interface Bundles    Recorders and Duplicators    USB Interface Bundles
@{LIST_SIGNAL PROCESSORS_MATERIAL_CATEGORY_L2}
@{LIST_SOFTWARE_MATERIAL_CATEGORY_L2}                                  Mobile Apps    Virtual Instrument Plugin
@{LIST_STANDS AND ACCESSORIES_MATERIAL_CATEGORY_L2}                    Desk Stand Mounts    Guitar and Bass Stands    Keyboard Stands    Lighting Stands
...                                                                    Loudspeaker Stands    Mic Stand Mounts    Microphone Stands    Mixer Stands    Music Stands
@{LIST_STUDIO CONTROLLERS AND METERS_MATERIAL_CATEGORY_L2}             Loudness Meters    Monitor Controllers
@{LIST_STUDIO RECORDING_MATERIAL_CATEGORY_L2}                          USB Audio Interfaces
@{LIST_SYNTHESIZERS AND KEYBOARDS_MATERIAL_CATEGORY_L2}                Desktop Samplers    Desktop Synthesizers and Sound Modules    Digital Pianos
...                                                                    Eurorack Synthesizers    Keyboard Amplifiers    Keyboard Synthesizers    Software
@{LIST_SYSTEM CONFIGURATION TOOLS_MATERIAL_CATEGORY_L2}                System Configuration Applications
@{LIST_VOICE PROCESSORS_MATERIAL_CATEGORY_L2}                          Accessories for Voice Processors    Merchandise    Mic Stand Mounts    Speakers and Monitors    Vocal Effects

@{LIST_ACCESSORIES FOR COMMERCIAL AMPLIFIERS_MATERIAL_CATEGORY_L3}     Controllers    Mounting Hardware
@{LIST_ACCESSORIES FOR LIGHTING_MATERIAL_CATEGORY_L3}                  Remote Controllers
@{LIST_ACCESSORIES FOR POWER AMPLIFIERS_MATERIAL_CATEGORY_L3}          Amplifier Racks    Mounting Hardware    Network Interface for Power Amplifiers
@{LIST_ACCESSORIES FOR SIGNAL PROCESSORS_MATERIAL_CATEGORY_L3}         500 Series Blank Panels    Road Cases
@{LIST_ACCESSORIES FOR VOICE PROCESSORS_MATERIAL_CATEGORY_L3}          Accessories for Voice Processors
@{LIST_ACOUSTIC INSTRUMENT AMPLIFIERS_MATERIAL_CATEGORY_L3}            Acoustic Instrument Combo Amplifiers
@{LIST_ADAPTERS_MATERIAL_CATEGORY_L3}                                  Adapter Cables
@{LIST_AMPLIFIER RACKS_MATERIAL_CATEGORY_L3}                           Rigging Hardware
@{LIST_ANALOG MIXERS_MATERIAL_CATEGORY_L3}                             Analog Mixers with Effects    Battery Powered Analog Mixers    Matrix Mixers    Meter Bridges
...                                                                    Mixer Automation    Power Supplies    Powered Mixers    Signal Splitters
@{LIST_ANALOG RACK MIXERS_MATERIAL_CATEGORY_L3}                        Analog Rack Mixers with Effects    Analog Zone Mixers    Signal Splitters
@{LIST_AUDIO AND EFFECTS PLUG-INS_MATERIAL_CATEGORY_L3}                Controllers
@{LIST_AUDIO CABLES_MATERIAL_CATEGORY_L3}                              Cables for Streaming
@{LIST_BASS AMPLIFIERS_MATERIAL_CATEGORY_L3}                           Bags for Bass Amplifiers    Bass Cabinets    Bass Combo Amplifiers    Bass Head Amplifiers
@{LIST_BLUETOOTH HEADPHONES_MATERIAL_CATEGORY_L3}                      Active Noise Canceling Headphones    In-Ear Monitors    True Wireless Stereo
@{LIST_BULK CABLES_MATERIAL_CATEGORY_L3}                               Bulk DMX Cables    Bulk Speaker Cables
@{LIST_CEILING SPEAKERS_MATERIAL_CATEGORY_L3}                          Back Cans    Mounts and Brackets    Passive Speakers    Passive Subwoofers    Powered Speakers    Speaker Grilles
@{LIST_COLUMN SPEAKERS_MATERIAL_CATEGORY_L3}                           Bags for Loudspeakers    I/O Interface for Steerable Speakers    Mounts and Brackets    Passive Speakers
...                                                                    Power Supplies for Steerable Speakers    Powered Speakers    Protective Covers    Rigging and Transport Hardware    Steerable Speakers
@{LIST_COMPRESSORS/LIMITERS_MATERIAL_CATEGORY_L3}                      500 Series Compressors/Limiters
@{LIST_COMPUTER CABLES_MATERIAL_CATEGORY_L3}                           USB Cables
@{LIST_CONFIGURATION APPLICATIONS_MATERIAL_CATEGORY_L3}                Mobile Applications
@{LIST_CONNECTORS_MATERIAL_CATEGORY_L3}                                Speaker Connectors    TS Connectors    XLR Connectors
@{LIST_DAW APPLICATIONS_MATERIAL_CATEGORY_L3}                          Desktop Applications
@{LIST_DESKTOP SYNTHESIZERS AND SOUND MODULES_MATERIAL_CATEGORY_L3}    Analog Drum Synthesizers    Analog Stringers    Analog Synthesizers    Bags for Synthesizers
...                                                                    Hybrid Synthesizers    Sequencer and Trigger Modules    Tape Echo    Theremin Synthesizers
@{LIST_DIGITAL COMMS/CUE SYSTEM_MATERIAL_CATEGORY_L3}                  Batteries for Beltpacks    Beltpacks    Charging Stations for Beltpacks
@{LIST_DIGITAL MIXERS_MATERIAL_CATEGORY_L3}                            Console Extensions    DSP Mixing Engines    Gooseneck Lamps    LCD Switches    Mixer Upgrade Kits
...                                                                    Mobile Applications    Motor Faders    Mounts and Brackets    Racks and Hardware    Road Cases
@{LIST_DJ MIXERS_MATERIAL_CATEGORY_L3}                                 Beat Counters    Faders    Power Supplies
@{LIST_EFFECT LIGHTING_MATERIAL_CATEGORY_L3}                           Color Changers    Derby and Strobe Lights    Flood Lights    Multi Effect Bars    Par Lighting Systems    Wireless Spotlights
@{LIST_EFFECT MACHINES_MATERIAL_CATEGORY_L3}                           Fog Machines    Hazer Machines
@{LIST_EFFECTS AND PEDALS_MATERIAL_CATEGORY_L3}                        Bags for Effects Pedals    Delay/Reverb    Distortion/Overdrive    Dynamics/Equalizers
...                                                                    Footswitches for Bass Amplifiers    Footswitches for Guitar Amplifiers    Footswitches for Keyboards
...                                                                    Loopers    Mobile Applications    Modelling Bass Amplifiers    Modelling Guitar Amplifiers    Multi-Effects for Bass
...                                                                    Multi-Effects for Guitar    Pedal Boards    Pedals for Acoustic Guitars    Pitch/Modulation    Power Supplies
...                                                                    Preamplifiers    Speciality Bass Effects    Speciality Guitar Effects    Volume/Expression    Wah Pedals
@{LIST_EQUALIZERS_MATERIAL_CATEGORY_L3}                                500 Series Equalizers    Controllers    Power Supplies
@{LIST_EURORACK SYNTHESIZERS_MATERIAL_CATEGORY_L3}                     Bags for Synthesizers    Controller Modules    Effects Modules    Envelope Modules
...                                                                    Eurorack Cases    Filter Modules    Interface Modules    LFO Modules    Mixer and Attenuator Modules
...                                                                    Modular Synthesizer Systems    Multiples and Divider Modules    Noise Modules    Oscillator Modules
...                                                                    Phase Shifter Modules    Power Supplies    Ring Modulators and Crossfader Modules    Sample and Hold Modules
...                                                                    Sequencer and Trigger Modules    Speciality Modules    Synthesizer Modules    VCA Modules
@{LIST_FIREWIRE INTERFACE BUNDLES_MATERIAL_CATEGORY_L3}                Podcast Bundles
@{LIST_GOOSENECK MICROPHONES_MATERIAL_CATEGORY_L3}                     Condenser Microphones    Dynamic Microphones
@{LIST_GUITAR AMPLIFIERS_MATERIAL_CATEGORY_L3}                         Attenuators for Guitar Amplifiers    Bags for Guitar Amplifiers    Guitar Cabinets    Guitar Combo Amplifiers
...                                                                    Guitar Head Amplifiers    Modelling Guitar Amplifiers    Protective Covers for Guitar Amplifiers    Protective Covers for Speaker Cabinets
...                                                                    Rack Mounts    Tubes for Guitar Amplifiers
@{LIST_HANDHELD MICROPHONES_MATERIAL_CATEGORY_L3}                      Condenser Microphones    Dynamic Microphones
@{LIST_HIFI SPEAKERS_MATERIAL_CATEGORY_L3}                             Desktop Applications    Home Theatre Systems    Mounts and Brackets    Passive Speakers    Powered Speakers
...                                                                    Powered Subwoofers    Soundbars
@{LIST_HIGH-END SPEAKERS_MATERIAL_CATEGORY_L3}                         Passive Speakers    Passive Subwoofers
@{LIST_HOME THEATRE SYSTEMS_MATERIAL_CATEGORY_L3}                      In-Wall Speakers    Mounts and Brackets    Passive Speakers    Passive Subwoofers
@{LIST_HORN SPEAKERS_MATERIAL_CATEGORY_L3}                             Passive Speakers
@{LIST_I/O INTERFACES_MATERIAL_CATEGORY_L3}                            Digital Converters    Expansion Cards and Interfaces    Signal Splitters    Stage Boxes
@{LIST_INSTRUMENT MICROPHONES_MATERIAL_CATEGORY_L3}                    Condenser Microphones    Dynamic Microphones    Instrument Microphone Kits
@{LIST_INTERCOM CONFIGURATION APPLICATIONS_MATERIAL_CATEGORY_L3}       Mobile Applications    Software Applications
@{LIST_IN-WALL SPEAKERS_MATERIAL_CATEGORY_L3}                          Back Cans    Mounts and Brackets    Passive Speakers    Passive Subwoofers    Speaker Grilles
@{LIST_LARGE DIAPHRAGM MICROPHONES_MATERIAL_CATEGORY_L3}               Condenser Microphones    Dynamic Microphones
@{LIST_LAVALIER MICROPHONES_MATERIAL_CATEGORY_L3}                      Condenser Microphones
@{LIST_LINE ARRAYS_MATERIAL_CATEGORY_L3}                               Accessories for Line Arrays    Mobile Applications    Passive Speakers    Passive Subwoofers
...                                                                    Powered Speakers    Powered Subwoofers    Protective Covers    Rigging and Transport Hardware
...                                                                    Rigging Hardware    Road Cases
@{LIST_LOUDSPEAKER BUNDLES_MATERIAL_CATEGORY_L3}                       Powered Speakers
@{LIST_LOUDSPEAKER COMPONENTS_MATERIAL_CATEGORY_L3}                    Coaxial Transducers    Full Range Transducers    High Frequency Transducers    Loudspeaker Components
...                                                                    Low Frequency Transducers    Mid Frequency Transducers    Passive Speakers
@{LIST_LOUDSPEAKER STANDS_MATERIAL_CATEGORY_L3}                        Distance Poles
@{LIST_MEASUREMENT MICROPHONES_MATERIAL_CATEGORY_L3}                   Condenser Microphones
@{LIST_MERCHANDISE_MATERIAL_CATEGORY_L3}                               Books    Brochures
@{LIST_MICROPHONE CABLES_MATERIAL_CATEGORY_L3}                         Cable Spool
@{LIST_MICROPHONE PREAMPLIFIERS_MATERIAL_CATEGORY_L3}                  500 Series Microphone Preamplifiers    Power Supplies
@{LIST_MICROPHONE STANDS_MATERIAL_CATEGORY_L3}                         Accessories for Microphone Stands
@{LIST_MIDI CONTROLLERS_MATERIAL_CATEGORY_L3}                          MIDI Footswitches    MIDI Keyboards
@{LIST_MOBILE DEVICE INTERFACES_MATERIAL_CATEGORY_L3}                  Mobile Applications    Power Supplies    Wireless Systems with Lavalier Microphone
@{LIST_MONITOR CONTROLLERS_MATERIAL_CATEGORY_L3}                       Active Studio and Monitor Controllers    Passive Studio and Monitor Controllers
@{LIST_MOVING HEADS_MATERIAL_CATEGORY_L3}                              Spot Moving Heads    Wash Moving Heads
@{LIST_MULTI-EFFECTS PROCESSORS_MATERIAL_CATEGORY_L3}                  Controllers    Expansions and Upgrades
@{LIST_MUSIC STANDS_MATERIAL_CATEGORY_L3}                              Tablet Stands
@{LIST_NETWORK CABLES_MATERIAL_CATEGORY_L3}                            Cat5 Cables    Optical Fibre Cables
@{LIST_NETWORKED DSP_MATERIAL_CATEGORY_L3}                             Controllers    I/O Interface Cards    I/O Interfaces
...                                                                    Matrix Mixers    Steerable Speakers
@{LIST_NETWORKED VIDEO_MATERIAL_CATEGORY_L3}                           Video Tranceivers
@{LIST_ONLINE BROADCAST INTERFACES_MATERIAL_CATEGORY_L3}               Podcasting Interfaces    Streaming Interfaces    Vocal Effects
@{LIST_PENDANT SPEAKERS_MATERIAL_CATEGORY_L3}                          Passive Speakers
@{LIST_POINT SOURCE SPEAKERS_MATERIAL_CATEGORY_L3}                     Bags for Loudspeakers    Mounts & Brackets    Mounts and Brackets    Passive Speakers
...                                                                    Passive Subwoofers    Powered Speakers    Powered Subwoofers    Rigging and Transport Hardware    Speaker Grilles
@{LIST_PORTABLE PA SPEAKERS_MATERIAL_CATEGORY_L3}                      Bags for Loudspeakers    Batteries    Battery Powered Speakers    Mounts and Brackets    Network Interface for Portable PA Speakers
...                                                                    Passive Speakers    Passive Stage Monitors    Passive Subwoofers    Powered Speakers    Powered Stage Monitors
...                                                                    Powered Subwoofers    Protective Covers
@{LIST_POWER AMPLIFIERS_MATERIAL_CATEGORY_L3}                          2-Channel Amplifiers
@{LIST_POWER AMPLIFIERS WITH DSP_MATERIAL_CATEGORY_L3}                 2-Channel Amplifiers    4-Channel Amplifiers    8-Channel Amplifiers    Desktop Applications
@{LIST_RACK FRAMES_MATERIAL_CATEGORY_L3}                               500 Series Rack Frames
@{LIST_RECORDERS AND DUPLICATORS_MATERIAL_CATEGORY_L3}                 Hard Disk Recorders
@{LIST_ROCK SPEAKERS_MATERIAL_CATEGORY_L3}                             Passive Speakers
@{LIST_SOFTWARE_MATERIAL_CATEGORY_L3}                                  Desktop Applications
@{LIST_STAGE MONITORS_MATERIAL_CATEGORY_L3}                            Passive Stage Monitors    Powered Stage Monitors
@{LIST_STUDIO MONITORS_MATERIAL_CATEGORY_L3}                           Passive Studio Monitors    Powered Studio Monitors    Powered Subwoofers
@{LIST_SUBWOOFERS_MATERIAL_CATEGORY_L3}                                Passive Subwoofers
@{LIST_SURFACE MOUNT SPEAKERS_MATERIAL_CATEGORY_L3}                    Mounts and Brackets    Passive Speakers    Passive Subwoofers    Powered Speakers    Powered Subwoofers
@{LIST_SYNTHESIZERS_MATERIAL_CATEGORY_L3}                              Keyboard Synthesizers
@{LIST_SYSTEM CONFIGURATION APPLICATIONS_MATERIAL_CATEGORY_L3}         Mobile Applications
@{LIST_THEATER LIGHTING_MATERIAL_CATEGORY_L3}                          Fresnel Spotlights    Theater Spotlights
@{LIST_TUNERS_MATERIAL_CATEGORY_L3}                                    Mobile Applications
@{LIST_USB AUDIO INTERFACES_MATERIAL_CATEGORY_L3}                      Podcast Bundles
@{LIST_USB INTERFACE BUNDLES_MATERIAL_CATEGORY_L3}                     Podcast Bundles
@{LIST_VIRTUAL INSTRUMENT PLUGIN_MATERIAL_CATEGORY_L3}                 Synthesizer
@{LIST_VOCAL EFFECTS_MATERIAL_CATEGORY_L3}                             Adapter Cables    Adaptive Tone    Bags for Voice Processors    Controllers    Correction
...                                                                    Desktop Applications    Distortion/Overdrive    Doubling    Echo    Footswitches for Voice Processors
...                                                                    Harmony    Loopers    Mobile Applications    Modelling    Multi-Effects    Power Supplies    Reverb
...                                                                    Vocoder    XLR Cables
@{LIST_VOCAL MICROPHONES_MATERIAL_CATEGORY_L3}                         Condenser Microphones    Dynamic Microphones    USB Microphones
@{LIST_WIRED IN-EAR MONITORING COMPONENTS_MATERIAL_CATEGORY_L3}        Beltpacks    Headphone Amplifiers    Mounting Brackets    Personal Mixers    System Hubs and Distribution Modules
@{LIST_WIRELESS MICROPHONES_MATERIAL_CATEGORY_L3}                      Wireless Audio Transmitters    Wireless Systems with Handheld Microphone
...                                                                    Wireless Systems with Headset Microphone    Wireless Systems with Lavalier Microphone

# Pending Locators
${IMG_REQUIREMENT}                        //label[@for='designReqAttachment']/following::input[@name='attachment'][1]
${IMG_REFERENCE}                          //label[@for='']/following::input[@name='attachment'][1]
${IMG_PRODUCT_3D}                         //label[@for='stpFile']/following::input[@name='attachment'][1]
${IMG_ROADMAP}                            //label[@for='designInformation']/following::input[@name='attachment'][1]

${TXT_BRAND_CATEGORY_LEAD}                //input[@formcontrolname='brandCategoryLeader']
${TXT_SERIES_NAME}                        //input[@formcontrolname='seriesName']
${TXT_MODEL_CODE}                         //input[@formcontrolname='modelCode']
${TXT_MODEL_NAME}                         //input[@formcontrolname='modelName']
${TXT_PRODUCT_FEATURE_LIST}               //textarea[@formcontrolname='productFeatureList']
${TXT_DESIGN_REQUIREMENT}                 //textarea[@formcontrolname='designReqParam']
${TXT_COMPETITOR1}                        //textarea[@formcontrolname='competitor1']
${TXT_COMPETITOR2}                        //textarea[@formcontrolname='competitor2']
${TXT_COMPETITOR3}                        //textarea[@formcontrolname='competitor3']
${TXT_REQUESTOR_NAME}                     //input[@formcontrolname='requestorName']
${TXT_PLM_PFI}                            //input[@formcontrolname='plmPfi']
${TXT_PERFORMANCE_PRODUCT_SPECIALIST}     //input[@formcontrolname='productSpecialist']
${TXT_LOGO_TEXT}                          //input[@formcontrolname='logoText']
${TXT_FILE_LINK}                          //input[@formcontrolname='fileLink']
${TXT_PANTONE_COLOR}                      //input[@formcontrolname='pantoneColor']

${TXT_PRODUCT_3D}
${TXT_ROADMAP}

${DDL_BRAND}                              //label[@for='brand']/following-sibling::div/select
${DDL_DEVELOPMENT_CLASSIFICATION}         //select[@formcontrolname='developmentClassification']
${DDL_PDI_TYPE}                           //select[@formcontrolname='pdiType']
${DDL_MATERIAL_CATEGORY_L1}               //select[@formcontrolname='materialCategoryL1']
${DDL_MATERIAL_CATEGORY_L2}               //select[@formcontrolname='materialCategoryL2']
${DDL_MATERIAL_CATEGORY_L3}               //select[@formcontrolname='materialCategoryL3']
${CBX_ARTWORK_APPROVED}
