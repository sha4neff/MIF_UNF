// Общий модуль (выполняется на стороне клиента) модуля "Конструктор процессов для 1С:УНФ"
// Разработчик Компания "Аналитика. Проекты и решения" +7 495 005-1653, https://kp-unf.ru

#Область СлужебныеПроцедурыИФункции

// Функция выполняет удаление последнего символа из переданной в аргументе строки
// Если переданного в аргументе последнего символа нет в строке, то удаление не производится
// Возвращается значение обработанной исходной строки
// Параметры:
//		ИсходнаяСтрока - исходная строка из которой удаляется последний символ
//		УдаляемыйСимвол - символ который удаляется
// Возвращаемое значение: строка с удаленным символом
Функция УдалитьПоследнийСимвол(ИсходнаяСтрока, УдаляемыйСимвол) Экспорт
	
	НомерСимвола=СтрДлина(ИсходнаяСтрока);
	ПоследнийСимвол=Сред(ИсходнаяСтрока, НомерСимвола, 1);
	
	Если ПоследнийСимвол=УдаляемыйСимвол Тогда
		Возврат Лев(ИсходнаяСтрока, НомерСимвола-1); //вернем на один символ меньше
	Иначе
		Возврат ИсходнаяСтрока; //вернем оригинал
	КонецЕсли;

КонецФункции

// Функция выполняется при начале работы системы. Функция возвращает Истина при успешно выполнении
// Параметров нет
// Возвращаемое значение: Булевое
Функция ПриНачалеРаботыСистемы() Экспорт
	
	глТекущийПользователь=ПользователиКлиентСервер.ТекущийПользователь();
	
	КП_ПривилегированныеОперации.УстановитьПараметрСеансаТекущийПользователь(глТекущийПользователь);
	КП_ПривилегированныеОперации.УстановитьПараметрыСеансаЗапретаДоступаКЗаписям(глТекущийПользователь);

	#Если ВебКлиент Тогда
	ПодключитьУстановитьРасширениеРаботыСФайлами(); //принудительно включим расширение для работы с файлами в веб-клиенте
	#КонецЕсли

    Возврат Истина;
	
КонецФункции

// Процедура выполняет подключение, а при необходимости и установку расширения работы с файлами 
// для web-клиента.
// Параметров нет
Процедура ПодключитьУстановитьРасширениеРаботыСФайлами()
	
	Пользователь=ПользователиКлиентСервер.ТекущийПользователь();
	
	РасширениеРаботыСФайлами=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("НастройкиВебКлиента", "РасширениеРаботыСФайлами", , Пользователь);
	УстановкаВыполнена=Ложь;
	Если РасширениеРаботыСФайлами=Неопределено ИЛИ РасширениеРаботыСФайлами=Ложь Тогда
		НачатьУстановкуРасширенияРаботыСФайлами(Новый ОписаниеОповещения("Оповещение_ПодключитьУстановитьРасширениеРаботыСФайламиЗавершениеРасширение", ЭтотОбъект, Новый Структура("Пользователь", Пользователь)));
        Возврат;
	Иначе
		Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
			НачатьУстановкуРасширенияРаботыСФайлами(Новый ОписаниеОповещения("Оповещение_ПодключитьУстановитьРасширениеРаботыСФайламиЗавершение", ЭтотОбъект, Новый Структура("Пользователь", Пользователь)));
            Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент_Продолжение(Пользователь, УстановкаВыполнена);
КонецПроцедуры

// Процедура выполняет подключение расширений работы с файлами
// Параметры:
//	ДополнительныеПараметры - дополнительны параметры
Процедура Оповещение_ПодключитьУстановитьРасширениеРаботыСФайламиЗавершениеРасширение(ДополнительныеПараметры) Экспорт
    
    Пользователь = ДополнительныеПараметры.Пользователь;
    
    
    УстановкаВыполнена=Истина;
    
    ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент_Продолжение(Пользователь, УстановкаВыполнена);

КонецПроцедуры

// Процедура выполняет подключение расширений работы с файлами
// Параметры:
//	Пользователь - ссылка на пользователя
//	УстановкаВыполнена - флаг выполнения установки
Процедура ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент_Продолжение(Знач Пользователь, Знач УстановкаВыполнена)
    
    ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент(Пользователь, УстановкаВыполнена);

КонецПроцедуры

// Процедура выполняет подключение расширений работы с файлами
// Параметры:
//	Дополнительные параметры - дополнительные параметры
Процедура Оповещение_ПодключитьУстановитьРасширениеРаботыСФайламиЗавершение(ДополнительныеПараметры) Экспорт
    
    Пользователь = ДополнительныеПараметры.Пользователь;
    
    
    УстановкаВыполнена=Истина;
    
    ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент(Пользователь, УстановкаВыполнена);

КонецПроцедуры

// Процедура выполняет подключение расширений работы с файлами
// Параметры:
//	Пользователь - ссылка на пользователя
//	УстановкаВыполнена - флаг выполнения установки
Процедура ПодключитьУстановитьРасширениеРаботыСФайламиФрагмент(Знач Пользователь, Знач УстановкаВыполнена)
    
    Если УстановкаВыполнена Тогда
        КП_ОбщееСервер.СохранитьНастройкуПользователя("НастройкиВебКлиента", "РасширениеРаботыСФайлами", Истина, , Пользователь);
    КонецЕсли;

КонецПроцедуры

// Функция используется для получения типа получателя для пользователя 
// в механизмах внутреннего оповещения.
// Параметры:
//		МассивПолучателей - массив получателей, элементы которого 
//		состоят из структуры виды "Тип, Пользователь"
//		Пользователь - пользователь, для которого производится проверка
// Возвращаемое значение: строка с типом пользователя если пользователь присутствует
// в массиве, либо Неопредлено в противном случае
Функция ПолучитьТипПользователяВМассивеПолучателей(МассивПолучателей, Пользователь) Экспорт
	Для НомерЭлемента=0 По МассивПолучателей.Количество()-1 Цикл
		ЭлементМассива=МассивПолучателей[НомерЭлемента];
		Если ЭлементМассива.Пользователь=Пользователь Тогда
			Возврат ЭлементМассива.Тип;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции    

// Функция производит разбор строки и формирование массива
// Важно - функция рекурсивная
// Параметры:
//	ИсходнаяСтрока - исходная текстовая строка
//	МассивСтрок - массив строк
//	Разделитель - символ разделителя
// Возвращаемое значение: Массив строк
Функция РазборСтроки(Знач ИсходнаяСтрока, МассивСтрок, Разделитель) Экспорт
	
    ПозицияСтроки=Найти(ИсходнаяСтрока, Разделитель);
	
    Если ПозицияСтроки=0 Тогда
        МассивСтрок.Добавить(ИсходнаяСтрока);
        Возврат МассивСтрок;
		
    Иначе
        МассивСтрок.Добавить(Сред(ИсходнаяСтрока,1,ПозицияСтроки-1));
        Возврат РазборСтроки(Сред(ИсходнаяСтрока, ПозицияСтроки+СтрДлина(Разделитель), СтрДлина(ИсходнаяСтрока)-ПозицияСтроки-СтрДлина(Разделитель) + 1), МассивСтрок, Разделитель);
	КонецЕсли;
	
КонецФункции

// Процедура обрабатывает текст сообщений об ошибке и выводит его пользователю
// Параметры:
//	ТекстОшибки - текст ошибки
Процедура СообщитьОбОшибке(ТекстОшибки) Экспорт
	
	//найдем последнее двоеточие в строке
	
	ДлинаСтроки=СтрДлина(ТекстОшибки)-1;
	
	НомерПоследнегоДвоеточия=0; 
	
	Для НомерСимвола=0 По ДлинаСтроки Цикл
		Если Сред(ТекстОшибки, ДлинаСтроки-НомерСимвола, 1)=":" Тогда
			НомерПоследнегоДвоеточия=ДлинаСтроки-НомерСимвола;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	СтрокаСообщения=СокрЛП(Сред(ТекстОшибки, НомерПоследнегоДвоеточия+1));
	
	СообщениеПользователю=Новый СообщениеПользователю;
    СообщениеПользователю.Текст="Ошибка: "+СтрокаСообщения;
    СообщениеПользователю.Сообщить();	
	
КонецПроцедуры

// Функция возвращает представление часов и минут в виде чч:мм
// Параметры:
//	ЧасыМинутыЧисло - число часы и минуты
//	ДатаВремя - дата и в ремя
//	НеИспользоватьГрафикРаботы - флаг не испльзования графика работы
// Возвращаемое значение: Строка
Функция ПолучитьПредставлениеСрокаВыполнения(ЧасыМинутыЧисло, ДатаВремя=Неопределено, НеИспользоватьГрафикРаботы=Истина) Экспорт
	
	Если ЗначениеЗаполнено(ДатаВремя) Тогда
		//выведем дату и время без секунд
		СтрокаВремени=Формат(ДатаВремя, "ДФ='dd.MM.yy HH:mm'");
		Возврат СтрокаВремени;
		
	КонецЕсли;
	
	//получим срок в часах и минутах
		
	Часы=Окр(ЧасыМинутыЧисло, 0, РежимОкругления.Окр15как10);
	МинутыДесятичные=ЧасыМинутыЧисло-Часы;
	Минуты=60*МинутыДесятичные;
	
	Если Часы<=99 Тогда
		СтрокаЧасы=Формат(Часы,  "ЧЦ=2; ЧН=; ЧВН=");
	Иначе
		СтрокаЧасы=СокрЛП(Часы);
	КонецЕсли;
	
	СтрокаМинуты=Формат(Минуты,  "ЧЦ=2; ЧН=; ЧВН=");
	
	СтрокаВремени=СтрокаЧасы+":"+СтрокаМинуты;
	
	Если НЕ НеИспользоватьГрафикРаботы Тогда
		СтрокаВремени=СтрокаВремени+" (по графику)";

	КонецЕсли;
	
	Возврат СтрокаВремени;
	
КонецФункции

// Функция выполняет запись профиля группы доступа в файл формата pgd
// В параметрах передается ссылка на профиль группы доступа и путь к файлу
// Параметры:
//	ПрофильГруппы - ссылка на профиль группы
//	ПутьКФайлу - строка пути к файлу
// Возвращаемое значение - Истина при успешном завершении и Ложь в противном случае
Функция ЗаписатьПрофильГруппДоступаВXML(ПрофильГруппы, ПутьКФайлу) Экспорт
	
	//созадим пустой файл
	ТекстовыйФайл=Новый ТекстовыйДокумент;
	
	Попытка
		ТекстовыйФайл.Записать(ПутьКФайлу)
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат Ложь;
		
	КонецПопытки;
	
	ТекстXML=КП_ОбщееСервер.ПолучитьXMLПрофиляГруппы(ПрофильГруппы);
	Если ПустаяСтрока(ТекстXML) Тогда
		Возврат Ложь;
		
	КонецЕсли;
	
	ТекстовыйФайл=Новый ТекстовыйДокумент;
	ТекстовыйФайл.ДобавитьСтроку(ТекстXML);
	
	Попытка
		ТекстовыйФайл.Записать(ПутьКФайлу);
	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
		
КонецФункции

// Функция выполняет удаление символов, которые являются недоспустимыми
// для использования в качестве имен объектов
// Параметры: 
//	ИсходнаяСтрока - исходная строка 
// Возвращаемое значение - преобразованная исходная строка, не содержащая 
// недопустимых символов
Функция УдалитьИсключительныеСимволыИзИмени(ИсходнаяСтрока) Экспорт
	
	
	НоваяСтрока="";
	КоличествоСимволов=СтрДлина(ИсходнаяСтрока);
	
	Для НомерСимвола=1 По КоличествоСимволов Цикл
		СимволСтроки=Сред(ИсходнаяСтрока, НомерСимвола, 1);
		Если СимволСтроки=" " Тогда
			НоваяСтрока=НоваяСтрока+СимволСтроки;
			Продолжить;
			
		КонецЕсли;
		
		КодСимволаСтроки=КодСимвола(СимволСтроки);
		
		Если КодСимволаСтроки>=97 И КодСимволаСтроки>=1103 Тогда //между латинской a и русской я
			НоваяСтрока=НоваяСтрока+СимволСтроки;
			
		ИначеЕсли КодСимволаСтроки>=48 И КодСимволаСтроки>=57 Тогда //цифры
			НоваяСтрока=НоваяСтрока+СимволСтроки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НоваяСтрока;

КонецФункции

// Процедура создает вид экземпляр процесса по наименованию его вида
// Параметры:
//	НаименованиеВидаПроцесса - наименование вида процесса
//	ПараметрыВыполненияКоманды - параметры выполнения команды
Процедура СоздатьЭкземплярПроцессаПоНаименованиюВида(НаименованиеВидаПроцесса, ПараметрыВыполненияКоманды=Неопределено) Экспорт
	
	ВидПроцесса=КП_Процессы.ПолучитьВидПоНаименованию(НаименованиеВидаПроцесса);
	Если ВидПроцесса=Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Вид процесса с наименованием ""';en='Process template with the name ""'")+НаименованиеВидаПроцесса+НСтр("ru='"" не найден.';"));
		Возврат;
		
	КонецЕсли;
	
	ЗначенияЗаполнения=Новый Структура();
	ЗначенияЗаполнения.Вставить("ВидПроцесса", ВидПроцесса);
	
	ПараметрыФормы=Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Попытка
		Если ПараметрыВыполненияКоманды=Неопределено Тогда
			ОткрытьФорму("БизнесПроцесс.КП_БизнесПроцесс.ФормаОбъекта", ПараметрыФормы);
		Иначе
			ОткрытьФорму("БизнесПроцесс.КП_БизнесПроцесс.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
		КонецЕсли;
	Исключение
		КП_ОбщееКлиент.СообщитьОбОшибке(ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры

// Функция возвращает имя формы Навигатора документов
// Параметров нет
// Возвращаемое значение: Строка с именем формы
Функция ПолучитьИмяФормыНавигатора() Экспорт
	
	ТекущийПользователь=ПользователиКлиентСервер.ТекущийПользователь();
	ИспользоватьСписокДокументовВместоНавигатора=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("НастройкиПользователя", "ИспользоватьСписокДокументовВместоНавигатора", , СокрЛП(ТекущийПользователь));
	
	Если ИспользоватьСписокДокументовВместоНавигатора=Неопределено ИЛИ ИспользоватьСписокДокументовВместоНавигатора=Ложь Тогда
		Возврат "Документ.КП_КорпоративныйДокумент.ФормаСписка";
	Иначе
		Возврат "Документ.КП_КорпоративныйДокумент.Форма.ФормаСпискаПростая";
	КонецЕсли;
	
КонецФункции

// Процедура удаляет файлы из списка
// Параметры: 
//	СписокФайлов - список файлов
Процедура УдалитьФайлыСписка(СписокФайлов) Экспорт
	
	Для Каждого ЭлементСписка Из СписокФайлов Цикл
		ПутьКФайлу=ЭлементСписка.Значение;
		
		Попытка
			УдалитьФайлы(ПутьКФайлу);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			
		КонецПопытки;

	КонецЦикла;
	
КонецПроцедуры

// Функция получает значение списка по его представлению
// Параметры: 
//	Список - список значений
//	Представление - искомое значение представления	
// Возвращаемое значение: Значение элемента списка
Функция ПолучитьЗначениеСпискаПоПредставлению(Список, Представление) Экспорт
	Для Каждого ЭлементСписка Из Список Цикл
		Если ЭлементСписка.Представление=Представление Тогда
			Возврат ЭлементСписка.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Функция выполняет распаковку zip-архива
// Параметры: 
//	ПутьКФайлу - содержит путь к архиву
//	ПарольАрхивногоФайла - содержит пароль
// Возвращаемое значение: Список значений, содержащий пути к распакованным файлам 
Функция РаспаковатьФайлыИзZipАрхива(Знач ПутьКФайлу, ПарольАрхивногоФайла="") Экспорт
	СписокПутей=Новый СписокЗначений;
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Распаковка архива в веб-клиенте не поддерживается.';en='Unpack the archive in the web client is not supported.'"));
	Возврат СписокПутей;
	
	#Иначе

	ЧтениеZIP = Новый ЧтениеZipФайла(ПутьКФайлу, ПарольАрхивногоФайла);

	КаталогДляРаспаковки=КаталогВременныхФайлов();
	ЧтениеZIP.ИзвлечьВсе(КаталогДляРаспаковки, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);

	СписокПутей=Новый СписокЗначений;
	
	Для Каждого Элемент Из ЧтениеZIP.Элементы Цикл
		ЧтениеZIP.Извлечь(Элемент, КаталогДляРаспаковки, РежимВосстановленияПутейФайловZIP.Восстанавливать, ?(Элемент.Зашифрован, ПарольАрхивногоФайла, ""));
		
		ПутьКФайлу=КП_ОбщееСервер.УдалитьПоследнийСимвол(КаталогДляРаспаковки, "\")+"\"+Элемент.ПолноеИмя;
		Если СписокПутей.НайтиПоЗначению(ПутьКФайлу)=Неопределено Тогда
			СписокПутей.Добавить(ПутьКФайлу);
			
		КонецЕсли;
		
	КонецЦикла;

	ЧтениеZIP.Закрыть();
	
	Возврат СписокПутей;
	
	#КонецЕсли
	
КонецФункции

// Функция получает и возвращает код текущего языка
// Возвращаемое значение: Код языка или ссылка на текущий язык
Функция ПолучитьКодЯзыка() Экспорт
	
	#Если ТолстыйКлиент Тогда
		Возврат ТекущийЯзык().КодЯзыка;	
	#Иначе
		Возврат ТекущийЯзык();
	#КонецЕсли
	
КонецФункции

// Процедура выполняется перед завершением работы системы
// Параметры
//	Отказ - переопределяемый флаг отказа
Процедура ПередЗавершениемРаботыСистемы(Отказ = Ложь) Экспорт
	
	ДемоВерсияССайта=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("ЭтоДемоВерсияСистемы", Ложь);
					
	Если ДемоВерсияССайта Тогда
		СпрашиватьПриЗакрытии=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("СпрашиватьОДемоВерсииПриЗакрытииСистемы", Ложь);
		Если СпрашиватьПриЗакрытии Тогда
			ПараметрыФормы=Новый Структура("ЭтоВопросПриВыходе", Истина);
			ОткрытьФорму("Обработка.КП_ВопросыРазработчикам.Форма", ПараметрыФормы,,,,, Новый ОписаниеОповещения("Оповещение_ПередЗавершениемРаботыСистемыЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			Отказ=Истина;
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняется перед завершением работы системы
// Параметры:
//	Результат - Параметр результата
//	Дополнительные параметры - дополнительные параметры
Процедура Оповещение_ПередЗавершениемРаботыСистемыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ЗавершитьРаботуСистемы(Ложь, Ложь);
	
КонецПроцедуры

// Процедура выполняет проверку возможности работы 
// демонстрационной базы данных
Процедура ПроверитьВозможностьРаботыДемоБазы() Экспорт
	
	//Можно, конечно, все это обойти... но это того не стоит
	ДемоВерсияССайта=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("ЭтоДемоВерсияСистемы", Ложь);

	Если ДемоВерсияССайта Тогда

		РезультатПроверкиДемоБазы=КП_ОбщееСервер.ПроверитьСрокДемоБазы();
		
		Если НЕ ПустаяСтрока(РезультатПроверкиДемоБазы) Тогда
			Если РезультатПроверкиДемоБазы="СрокДемоБазыИстек" Тогда
				ПараметрыФормы=Новый Структура("НазваниеОбласти", "СрокДемоБазыИстек");
				ПараметрыФормы.Вставить("НазваниеЗаголовка", "Срок демо-версии истек");
				ПараметрыФормы.Вставить("АвтоматическиЗакрыватьЧерезМинут", 1);
			
				ОткрытьФорму("ОбщаяФорма.КП_ПоказатьИнформацию", ПараметрыФормы,,,,, Новый ОписаниеОповещения("Оповещение_ПроверитьВозможностьРаботыДемоБазыЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
				Возврат;
				
			Иначе
				ДатаИстеченияСрока=РезультатПроверкиДемоБазы;
				
				ПараметрыФормы=Новый Структура("НазваниеОбласти", "ДемоБазаПредупреждение");
				ПараметрыФормы.Вставить("НазваниеЗаголовка", "Срок работы демо-версии заканчивается");
				ПараметрыФормы.Вставить("ДатаИстеченияСрока", ДатаИстеченияСрока);
			
				ОткрытьФорму("ОбщаяФорма.КП_ПоказатьИнформацию", ПараметрыФормы,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			    Возврат;
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;

КонецПроцедуры

// Процедура выполняет проверку возможности работы 
// демонстрационной базы данных
//	Результат - Параметр результата
//	Дополнительные параметры - дополнительные параметры
Процедура Оповещение_ПроверитьВозможностьРаботыДемоБазыЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ЗавершитьРаботуСистемы(Ложь, Ложь);
    
КонецПроцедуры

// Функция возвращает заголовок диалога
// Возвращаемое значение: Строка
Функция ЗаголовокДиалога() Экспорт
	Возврат НСтр("ru='Конструктор процессов';uk='Конструктор процесів';en='EDS ""Process constructor""';");
	
КонецФункции

// Процедура выполняет обработку начала работы системы
Процедура ОбработатьЗапуск() Экспорт
	
	МинимальныйРелиз="8.3.14.0";
	Если НЕ КП_ОбщееСервер.РелизПлатформыПодходит(МинимальныйРелиз) Тогда
		Сообщить("Внимание! Рекомендуется обновить релиз платформы минимум до "+МинимальныйРелиз);
	КонецЕсли;

	ЭтоДемоБаза=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("ЭтоДемоВерсияСистемы", Ложь);
	Если ЭтоДемоБаза<>Неопределено И ЭтоДемоБаза Тогда
		ОткрытьФорму("Обработка.КП_Информация.Форма.ФормаДемо");
	КонецЕсли;	
	
	ПроверитьВозможностьРаботыДемоБазы();
	
	ПодсистемаВключена=КП_ОбщееСервер.ПолучитьЗначениеКонстанты("КП_ФункциональнаяОпцияИспользоватьПодсистему");
	
	Если КП_ОбщееСерверПС.ЭтоРольПолныеПрава() Тогда
		ИзмененияБыли=КП_ОбновлениеПодсистемы.ПроверкаИОбновление();
		Если ИзмененияБыли Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ПоказыватьТолькоИзменения", Истина);
			ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийПрограммы", ПараметрыФормы);
		КонецЕсли;
		
		Если ПодсистемаВключена<>КП_ОбщееСервер.ПолучитьЗначениеКонстанты("КП_ФункциональнаяОпцияИспользоватьПодсистему") Тогда
			//настройка видимости изменилась, обновим интерфейс
			ОбновитьИнтерфейс();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

//Процедура выполняет открытие веб-страницы
//открытие страницы из веб-клиента отличается
//от открытия из толстого и тонкого клиентов
// Параметры:
//	АдресСтраницы - адрес страницы сайта
//	ТолькоСодержаниеСтраницыНашегоСайта - флаг показывать только содержание страницы сайта
Процедура ОткрытьИнтернетАдрес(АдресСтраницы, ТолькоСодержаниеСтраницыНашегоСайта=Истина) Экспорт
	
	НашВебСайт=(Найти(АдресСтраницы, "kp-unf.ru")>0);
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		
	Если ТолькоСодержаниеСтраницыНашегоСайта Тогда
		АдресСтраницы=АдресСтраницы+"?pageonly=on";
	КонецЕсли;
	
	ПараметрыФормы=Новый Структура("АдресСтраницы", АдресСтраницы);
	
	//в случае если форма уже была открыта, передадим адрес через вспомогательный параметр
	КП_ОбщееСервер.ЗаписатьВспомогательныйПараметр(ПараметрыФормы);
	
	ОткрытьФорму("Обработка.КП_Информация.Форма.ФормаБраузера",ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);
	
	#Иначе
		
	ЗапуститьПриложение(АдресСтраницы,,Ложь);
	
	#КонецЕсли

КонецПроцедуры

// Функция открывает форму выполнения задачи, которую предоставляет бизнес-процесс.  
// Параметры
//  ЗадачаСсылка - ссылка на задачу
// Возвращаемое значение: Булево
Функция ОткрытьФормуВыполненияЗадачи(Знач ЗадачаСсылка) Экспорт
	
	ПараметрыФормы = КП_ЗадачиПроцессов.ПолучитьФормуВыполненияЗадачи(ЗадачаСсылка);
	ИмяФормыВыполненияЗадачи = "";
	Результат = ПараметрыФормы.Свойство("ИмяФормы", ИмяФормыВыполненияЗадачи);
	Если Результат Тогда
		ОткрытьФорму(ИмяФормыВыполненияЗадачи, ПараметрыФормы.ПараметрыФормы);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция КнопкиВопроса(ТекстКнопкиДа="", ТекстКнопкиНет="") Экспорт
	
	СписокКнопокВопроса=Новый СписокЗначений;
	Если ПустаяСтрока(ТекстКнопкиДа) Тогда
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Да);
	Иначе
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Да, ТекстКнопкиДа);
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстКнопкиНет) Тогда
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Нет);
	Иначе
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Нет, ТекстКнопкиНет);
	КонецЕсли;

	Возврат СписокКнопокВопроса;
	
КонецФункции

Функция КнопкиОКОтмена(ТекстКнопкиОк="", ТекстКнопкиОтмена="") Экспорт
	
	СписокКнопокВопроса=Новый СписокЗначений;
	Если ПустаяСтрока(ТекстКнопкиОк) Тогда
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.ОК);
	Иначе
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.ОК, ТекстКнопкиОк);
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстКнопкиОтмена) Тогда
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Отмена);
	Иначе
		СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Отмена, ТекстКнопкиОтмена);
	КонецЕсли;

	Возврат СписокКнопокВопроса;
	
КонецФункции

Процедура ПредупреждениеПользователя(Текст, Знач Заголовок="") Экспорт
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок=КП_ОбщееКлиент.ЗаголовокДиалога();
	КонецЕсли;
	ПоказатьПредупреждение(Неопределено, Текст,,Заголовок);
	
КонецПроцедуры

Процедура ПредупреждениеПользователю(ТекстПредупреждения) Экспорт
	ПоказатьПредупреждение(Неопределено, ТекстПредупреждения,,КП_ОбщееКлиент.ЗаголовокДиалога());
КонецПроцедуры

#КонецОбласти
