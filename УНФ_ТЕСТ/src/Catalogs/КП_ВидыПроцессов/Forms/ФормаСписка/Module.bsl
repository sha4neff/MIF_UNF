
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//{Режим открытия окна
	#Если ВебКлиент Тогда
		ЭтоВебКлиент=Истина;
	#Иначе
		ЭтоВебКлиент=Ложь;
	#КонецЕсли
	//}
	
	РежимВыбора=ЭтаФорма.Параметры.РежимВыбора;
	Элементы.Список.РежимВыбора=РежимВыбора;
	Элементы.ФормаСоздатьЭкземплярПроцесса.Видимость=НЕ РежимВыбора;
	Элементы.ФормаГруппаБиблиотека.Видимость=НЕ РежимВыбора;
	Элементы.ФормаСкопировать.Видимость=НЕ РежимВыбора;
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок=Параметры.Заголовок;
		ЭтаФорма.АвтоЗаголовок=Ложь;
	КонецЕсли;
	
	ТекущийПользователь=Пользователи.ТекущийПользователь();
	
	ПрочитатьНастройкиСервером();
	
	ОбновитьСписок();
	
	УстановитьОтображениеЭлементов();
	
	Если Элементы.Список.РежимВыбора И Параметры.Свойство("ТекущееЗначениеВыбора") Тогда
		//выберем значение в форме
		Элементы.Список.ТекущаяСтрока=Параметры.ТекущееЗначениеВыбора;
	КонецЕсли;
	
	Если СокрЛП(ТекущийПользователь.ИдентификаторПользователяИБ)="00000000-0000-0000-0000-000000000000" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='You are logged in with a user base of <N>. Some functions will not be available. Enter the database by selecting one of the available users.';ru='Вы вошли в базу с пользователем <Не указан>. Часть функционала будет не доступна. Войдите в базу данных, выбрав одного из доступных пользователей.'"));
		Элементы.ФормаСкопировать.Видимость=Ложь;	
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПоказыватьСхемуПроцессов Тогда
		Возврат;
		
	КонецЕсли;
	
	ВыбраннаяСтрока=Элементы.Список.ТекущаяСтрока;
	
	Если ВыбраннаяСтрока=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьСхемуВидаКБП(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ВидПроцесса=Элементы.Список.ТекущаяСтрока;
	
	Если Копирование Тогда
		
		ВидПроцесса=Элементы.Список.ТекущаяСтрока;
		
		Если НЕ ВидПроцесса=Неопределено Тогда
			Если КП_ОбщееСервер.ПолучитьЗначениеРеквизитаОбъекта(ВидПроцесса, "ЭтоГруппа") Тогда
				//обычное копирование группы
				Возврат;
			Иначе
				//это процесс
				Отказ=Истина;  //отменим стандартное копирование
				СоздатьКопиюПроцесса();
				Возврат;

			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если НЕ ЕстьВидыПроцессов() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("СписокПередНачаломДобавленияВопросОЗагрузкеИзБиблиотекиЗавершение", ЭтотОбъект), НСтр("en='There are no templates in the list. Do you want to create standart templates?';ru='В базе данных пока нет ни одного вида процесса. Загрузить виды из списка типовых процессов?'"), РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Нет, КП_ОбщееКлиент.ЗаголовокДиалога(), КодВозвратаДиалога.ОК);
		Отказ=Истина;
		Возврат;
	КонецЕсли;
	#КонецЕсли	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйПроектПриИзменении(Элемент)
	ОбновитьСписок();
	ЗаписатьНастройкиСервером();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьЭкземплярПроцесса(Команда)
	
	ВыбраннаяСтрока=Элементы.Список.ТекущаяСтрока;
	
	Если ВыбраннаяСтрока=Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Вид процесса не был выбран. Экземпляр не может быть создан.';en='Process type was not selected.';"),,КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если КП_ОбщееСервер.ПолучитьЗначениеРеквизитаОбъекта(ВыбраннаяСтрока, "ПометкаУдаления") Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Вид процесса помечен на удаление. Экземпляр не может быть создан.';en='Process type is marked for deletion.';"),,КП_ОбщееКлиент.ЗаголовокДиалога());
		Отказ=Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭлементыСправочникаСуществуют()  Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please create or download business process type first.';ru='Сначала создайте или загрузите вид бизнес-процесса.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please select the type of business process.';ru='Сначала выберите вид бизнес-процесса.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если КП_ОбщееСерверПС.ЭтоГруппаСправочника(ВыбраннаяСтрока) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please select the type of business process, not a group.';ru='Выберите вид бизнес-процесса, а не группу.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;		
	
	СписокКнопокВопроса=Новый СписокЗначений;
	СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Да, "Да, создать");
	СписокКнопокВопроса.Добавить(КодВозвратаДиалога.Нет);
	
	ПоказатьВопрос(Новый ОписаниеОповещения("Оповещение_СоздатьЭкземплярПроцессаЗавершение", ЭтотОбъект, Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока)), 
		НСтр("en='Do you want to create an instance of the business process flowchart ""';ru='Создать экземпляр бизнес-процесса ""'")+СокрЛП(ВыбраннаяСтрока)+"""?", 
		СписокКнопокВопроса, 60, , КП_ОбщееКлиент.ЗаголовокДиалога());
			
КонецПроцедуры

&НаКлиенте
Процедура Оповещение_СоздатьЭкземплярПроцессаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
    
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    Состояние(НСтр("en='Creating the process ...';ru='Создание экземпляра процесса...'"),,,БиблиотекаКартинок.ДлительнаяОперация48);
    
    ЗначенияЗаполнения=Новый Структура();
    ЗначенияЗаполнения.Вставить("ВидПроцесса", ВыбраннаяСтрока);
    
    ПараметрыФормы=Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
    
    Попытка
        ОткрытьФорму("БизнесПроцесс.КП_БизнесПроцесс.ФормаОбъекта", ПараметрыФормы);
    Исключение
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
    КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ПоказатьСхемуВидаКБП(СсылкаНаВидКБП)
	
	Если СсылкаНаВидКБП=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СсылкаНаВидКБП.ЭтоГруппа Тогда
		Возврат;
		
	КонецЕсли;
	
	ХранилищеКарты=СсылкаНаВидКБП.ХранилищеКартыПроцесса.Получить();
	Если НЕ ХранилищеКарты=Неопределено Тогда
		СхемаВидаКБП=ХранилищеКарты;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ВидБизнесПроцесса" И Параметр="Записан" Тогда
		
		ВыбраннаяСтрока=Элементы.Список.ТекущаяСтрока;
		
		Если ВыбраннаяСтрока=Источник Тогда
			ПоказатьСхемуВидаКБП(ВыбраннаяСтрока);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаВидаКБПВыбор(Элемент)
	
	ВыбраннаяСтрока=Элементы.Список.ТекущаяСтрока;
	ЭтоГруппа=КП_ОбщееСервер.ПолучитьРеквизитОбъекта(ВыбраннаяСтрока, "ЭтоГруппа");
	
	Если ВыбраннаяСтрока=Неопределено ИЛИ ЭтоГруппа Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Select the line with the business process.';ru='Выберите строку с бизнес-процессом.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("СхемаВидаКБПВыборЗавершение", ЭтотОбъект, Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока)), НСтр("en='Do you want to open flowchart for editing?';ru='Открыть схему для редактирования?'"), РежимДиалогаВопрос.ДаНет, 60, ,КП_ОбщееКлиент.ЗаголовокДиалога());
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаВидаКБПВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
    
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ПоказатьЗначение(Неопределено, ВыбраннаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайлXML(Команда)
	
	СтрокаВида=Элементы.Список.ТекущаяСтрока;
	
	Если СтрокаВида=Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please select the type of process to save the file.';ru='Выберите вид корпоративного процесса для сохранения в файл.'"), 60,КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
		
	КонецЕсли;
	
	Если КП_ОбщееСерверПС.ЭтоГруппаСправочника(СтрокаВида) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please select the type of process, not a group.';ru='Выберите вид корпоративного процесса, а не группу.'"), 60,КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
		
	КонецЕсли;
	
	ТолькоПредопределенные=Истина;
	СписокТребуемыхОтчетов=КП_Процессы.СписокТребуемыхРезультатовВВидеПроцесса(СтрокаВида, ТолькоПредопределенные);
	
	Если СписокТребуемыхОтчетов.Количество()=0 Тогда
		ВыгрузкаВФайлXMLПродолжение(СтрокаВида);
		
	Иначе
		СтрокаВопроса=НСтр("ru='Внимание! В виде процесса используются предопределенные требуемые 
						|от исполнителей результаты (точка ""'; en='Predefined elements of ""User required results"" was found in the process (point ""';");
		СтрокаВопроса=СтрокаВопроса+СокрЛП(СписокТребуемыхОтчетов[0].Представление);
		СтрокаВопроса=СтрокаВопроса+НСтр("ru='""). При загрузке они не будут прочитаны. 
						|Продолжить выгрузку вида процесса? '; en='""). They won''t be read. Do you want to continue?';");
						
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОПродолженииВыгрузкиСПредопределеннымиЗавершение", ЭтотОбъект, Новый Структура("СтрокаВида",СтрокаВида)), СтрокаВопроса, РежимДиалогаВопрос.ДаНет, 60, , КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаВФайлXMLПродолжение(СтрокаВида)
	
	//выберем файл для записи
	ФильтрРасширений=НСтр("en='bpl-files (*.bpl) | *.bpl';ru='bpl-файлы(*.bpl)|*.bpl'");
	ИмяФайла=СокрЛП(СтрокаВида);
	ИмяФайла=СтрЗаменить(ИмяФайла, """", "");
	ИмяФайла=СтрЗаменить(ИмяФайла, ":", " ");
	ИмяФайла=СтрЗаменить(ИмяФайла, "/", " ");
	
	ПутьКФайлу=КП_РаботаСФайламиКлиент.ВыбратьФайлСДиска(РежимДиалогаВыбораФайла.Сохранение, ФильтрРасширений,,ИмяФайла);
	
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		Состояние(НСтр("en='The file was not saved ...';ru='Файл не сохранен...'"));
		Возврат;
		
	КонецЕсли;
	
	ОчиститьСообщения();
	ЗаписанУспешно=КП_СхемаКБПКлиент.ЗаписатьВидКорпоративногоПроцессаXML(СтрокаВида, ПутьКФайлу);
	
	Если ЗаписанУспешно Тогда
		//получим размер файла
		ФайлВидаПроцесса=Новый Файл(ПутьКФайлу);
		РазмерФайлаКБ=Формат(ФайлВидаПроцесса.Размер()/1024, "ЧЦ=20; ЧДЦ=2");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Размер файла: ';")+СокрЛП(РазмерФайлаКБ)+НСтр("ru=' КБ.';"));

		Состояние(НСтр("en='Saved to the file ""';ru='Сохранен в файл ""'")+ПутьКФайлу+НСтр("ru='""';"));
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПродолженииВыгрузкиСПредопределеннымиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт		
	
	Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
        
    КонецЕсли;
	
	СтрокаВида=ДополнительныеПараметры.СтрокаВида;
	ВыгрузкаВФайлXMLПродолжение(СтрокаВида);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаXML(Команда)
	
	//выберем файл для загрузки
	ФильтрРасширений=НСтр("en='bpl-files (*.bpl), zip-archive (*.zip) | *.bpl; *. zip';ru='bpl-файлы(*.bpl), zip-архив(*.zip)|*.bpl; *.zip'");
	ПутьКФайлу=КП_РаботаСФайламиКлиент.ВыбратьФайлСДиска(РежимДиалогаВыбораФайла.Открытие, ФильтрРасширений);
	
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		Состояние(НСтр("en='The file was not selected ...';ru='Файл для загрузки не выбран...'"));
		Возврат;
		
	КонецЕсли;
	
	ФайлВАрхиве=Ложь;
	
	Если НРег(Прав(ПутьКФайлу, 4))=".zip" Тогда
		//распакуем архив во временный каталог
		Пароль="";
		СписокФайлов=КП_ОбщееКлиент.РаспаковатьФайлыИзZipАрхива(ПутьКФайлу, Пароль);
		
		ФайлыВАрхиве=(СписокФайлов.Количество()>0);

		ЗагруженоПроцессов=0;
		
		Для Каждого ЭлементСписка Из СписокФайлов Цикл
			ПутьКРаспакованномуФайлу=ЭлементСписка.Значение;
			Если НРег(Прав(ПутьКРаспакованномуФайлу, 4))=".bpl" Тогда
				//это файл вида процесса
				ПутьКФайлу=ПутьКРаспакованномуФайлу;
								
				//проверим наличие файла на диске
				Файл = Новый Файл(ПутьКФайлу);
				Если НЕ Файл.Существует() Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='File ""';ru='Файл ""'")+ПутьКФайлу+НСтр("ru='"" не существует или у учетной записи нет прав доступа.'; en='"" does not exist or your have no rights.';"));
					Возврат;
				КонецЕсли;
				
				//прочитаем файл
				ТекстФайла=Новый ТекстовыйДокумент;
				ТекстФайла.Прочитать(ПутьКФайлу);
				СтрокаXML=ТекстФайла.ПолучитьТекст();
				ВыводитьСообщения=Истина;
				
				//загрузим xml-объект
				ЗагруженныйОбъект=КП_СхемаКБПСервер.ПрочитатьВидПроцессаXML(СтрокаXML, ВыводитьСообщения);
				Если ЗагруженныйОбъект=Неопределено Тогда
					Продолжить;
		
				КонецЕсли;
				
				ЗагруженоПроцессов=ЗагруженоПроцессов+1;
		
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе //это не архив файлов
		
			//проверим наличие файла на диске
			Файл = Новый Файл(ПутьКФайлу);
			Если НЕ Файл.Существует() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='File ""';ru='Файл ""'")+ПутьКФайлу+НСтр("ru='"" не существует или у учетной записи нет прав доступа.'; en='"" does not exist or your have no rights.';"));
				Возврат;
			КонецЕсли;
			
			//прочитаем файл
			ТекстФайла=Новый ТекстовыйДокумент;
			ТекстФайла.Прочитать(ПутьКФайлу);
			СтрокаXML=ТекстФайла.ПолучитьТекст();
			ВыводитьСообщения=Истина;
			
			//загрузим xml-объект
			ЗагруженныйОбъект=КП_СхемаКБПСервер.ПрочитатьВидПроцессаXML(СтрокаXML, ВыводитьСообщения);
			Если ЗагруженныйОбъект=Неопределено Тогда
				Возврат;
	
			КонецЕсли;
			
			ЗагруженоПроцессов=1;

	КонецЕсли; //архив или bpl-файл
		
	Элементы.Список.Обновить();
	
	Если ЗагруженоПроцессов=1 Тогда
		ТекстПредупреждения=НСтр("ru='Вид бизнес-процесса успешно загружен!
					    |Проверьте наличие исполнителей ролей, прямые ссылки на исполнителей
					    |и другие параметры загруженного вида бизнес-процесса.';
					    |en='Business process successfully loaded.
						|Check users and other parameters of business process.';");
					   
	ИначеЕсли ЗагруженоПроцессов>0 Тогда
		Если ТекущийЯзыкСистемы()="en" Тогда
			ТекстПредупреждения="Sucessfully loaded "+Формат(ЗагруженоПроцессов, "ЧЦ=5; ЧН=; ЧГ=")+" business processes.
					   |Check users and other parameters of business processes.";
			
		Иначе
			ТекстПредупреждения="Загружено "+Формат(ЗагруженоПроцессов, "ЧЦ=5; ЧН=; ЧГ=")+" видов бизнес-процессов.
					   |Проверьте наличие исполнителей ролей, прямые ссылки на исполнителей
					   |и другие параметры в загруженных видах бизнес-процессов."
		КонецЕсли;	
					   
	Иначе
		ТекстПредупреждения=НСтр("ru='Бизнес-процессы из файла не загружены.
						|Возможно файл не содержит данных о виде бизнес-процесса.';
						|en='Business process was not successfully loaded.';");
		
	КонецЕсли;
	
	ПоказатьПредупреждение(Новый ОписаниеОповещения("ЗагрузитьИзФайлаXMLЗавершение", ЭтотОбъект, Новый Структура("ЗагруженныйОбъект, ЗагруженоПроцессов", ЗагруженныйОбъект, ЗагруженоПроцессов)), ТекстПредупреждения, 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаXMLЗавершение(ДополнительныеПараметры) Экспорт
    
    ЗагруженныйОбъект = ДополнительныеПараметры.ЗагруженныйОбъект;
    ЗагруженоПроцессов = ДополнительныеПараметры.ЗагруженоПроцессов;
    
    
    Если ЗначениеЗаполнено(ЗагруженныйОбъект) И ЗагруженоПроцессов=1 Тогда
        ПараметрыФормы=Новый Структура("Ключ", КП_ОбщееСервер.ПолучитьЗначениеРеквизитаОбъекта(ЗагруженныйОбъект, "Ссылка"));
        
        ФормаВидаПроцесса=ПолучитьФорму("Справочник.КП_ВидыПроцессов.ФормаОбъекта", ПараметрыФормы);
        ФормаВидаПроцесса.Открыть();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьНаСервереXML(Команда)
	ПоказатьПредупреждение(Неопределено, НСтр("en='This version is not available.';ru='В данной версии не доступно.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьССервераXML(Команда)
	ПоказатьПредупреждение(Неопределено, НСтр("en='This version is not available.';ru='В данной версии не доступно.'"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеЭлементов()
	Элементы.СхемаВидаКБП.Видимость=ПоказыватьСхемуПроцессов;
	
	ВестиУчетПоПроектам=ПолучитьФункциональнуюОпцию("УчетПоПроектам");
	Элементы.ВыбранныйПроект.Видимость=ВестиУчетПоПроектам;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСхемуПроцессовПриИзменении(Элемент)
	УстановитьОтображениеЭлементов();
	ЗаписатьНастройкиСервером();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаССервера(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузкаССервераЗавершение", ЭтотОбъект), НСтр("en='Do you want to open business processes online library?';ru='Открыть страницу сервера с библиотекой бизнес-процессов?'"), РежимДиалогаВопрос.ДаНет,,, КП_ОбщееКлиент.ЗаголовокДиалога());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаССервераЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
        
    КонецЕсли;
    
    СтраницаСервера="http://xn--90afdtkhdeabaxvge.net/library/business-processes.php";
    
    ЗапуститьПриложение(СтраницаСервера);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияВопросОЗагрузкеИзБиблиотекиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса=КодВозвратаДиалога.Да Тогда
        //откроем форму выбора типовых видов процесса
        ТиповыеВидыПроцессов(Неопределено);
		
	Иначе
		//создадим новый элемент
		ОткрытьФорму("Справочник.КП_ВидыПроцессов.ФормаОбъекта",,,,,, Неопределено);
		
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТиповыеВидыПроцессов(Команда)
	
	ОткрытьФорму("Справочник.КП_ВидыПроцессов.Форма.ФормаЗагрузкиТиповыхВидов",,,,,, Новый ОписаниеОповещения("ТиповыеВидыПроцессовВыгрузкаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ТиповыеВидыПроцессовВыгрузкаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РезультатОткрытия=Результат;
    
    Если НЕ ТипЗнч(РезультатОткрытия)=Тип("СписокЗначений") Тогда
        Возврат;
        
    КонецЕсли;
    
    СоздатьВидыПроцессов(РезультатОткрытия);

КонецПроцедуры

&НаКлиенте
Процедура ТиповыеВидыПроцессовЗавершение(ДополнительныеПараметры) Экспорт
    
    

КонецПроцедуры

&НаКлиенте
Процедура СоздатьВидыПроцессов(СписокИменМакетов)
	
	#Если ВебКлиент Тогда
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='This operation is not available on the web client.';ru='Данная операция недоступна на веб-клиенте. Воспользуйтесь тонким (thin) клиентом для настройки процессов.'"));
	Возврат;
	#Иначе

	ПапкаВременныхФайлов=КП_ОбщееСервер.УдалитьПоследнийСимвол(КаталогВременныхФайлов(), "\");
	
	Для Каждого ЭлементСписка Из СписокИменМакетов Цикл
		ИмяМакета=ЭлементСписка.Значение;
		Попытка
			ДвоичныеДанныеМакета=ПолучитьДвоичныеДанныеМакета(ИмяМакета);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Возврат;
		КонецПопытки;
		
		Если ДвоичныеДанныеМакета=Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Failure to get the binary data from the layout.';ru='Ошибка получения двоичных данных из макета.'"));
			Продолжить;
		КонецЕсли;
		
		//создадим новый вид
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Create the view of the ""';ru='Создание вида процесса ""'")+СокрЛП(ЭлементСписка.Представление)+НСтр("ru='""...';"));
		
		ПутьКВременномуФайлу=ПапкаВременныхФайлов+"\"+СокрЛП(ИмяМакета)+".bpl";
		
		Попытка
			ДвоичныеДанныеМакета.Записать(ПутьКВременномуФайлу);
			
			//загрузим процесс
			
			Файл = Новый Файл(ПутьКВременномуФайлу);
			Если НЕ Файл.Существует() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='File ""';ru='Файл ""'")+ПутьКВременномуФайлу+НСтр("ru='"" не существует или у учетной записи нет прав доступа.';"));
				Возврат;
			КонецЕсли;
			
			ТекстФайла=Новый ТекстовыйДокумент;
			ТекстФайла.Прочитать(ПутьКВременномуФайлу);
			СтрокаXML=ТекстФайла.ПолучитьТекст();
			
			//ЗаменитьСсылкиФайлаНаСсылкиНашейБазы(СтрокаXML);
			
			ВыводитьСообщения=Истина;
			ЗагруженныйВидПроцесса=КП_СхемаКБПСервер.ПрочитатьВидПроцессаXML(СтрокаXML, ВыводитьСообщения);
			
			УдалитьФайлы(ПутьКВременномуФайлу);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Продолжить;
			
		КонецПопытки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Create the look of the ""';ru='Создан вид процесса ""'")+СокрЛП(ЭлементСписка.Представление)+""".");
		
	КонецЦикла;
        
	Элементы.Список.Обновить();
	
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДвоичныеДанныеМакета(ИмяМакета)
	
	Попытка
		Возврат Справочники.КП_ВидыПроцессов.ПолучитьМакет(ИмяМакета);
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция ЕстьВидыПроцессов()
	
	Запрос=Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                    |	КП_ВидыПроцессов.Ссылка
	                    |ИЗ
	                    |	Справочник.КП_ВидыПроцессов КАК КП_ВидыПроцессов");
						
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Возврат Выборка.Следующий();

КонецФункции

&НаСервере
Функция ЭлементыСправочникаСуществуют()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыбораПоСправочнику=Справочники.КП_ВидыПроцессов.Выбрать();
	Возврат ВыбораПоСправочнику.Следующий();
	
КонецФункции

&НаКлиенте
Процедура ПоказыватьСистемыеПроцессыПриИзменении(Элемент)
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиСервером()
	
	Пользователь=СокрЛП(ТекущийПользователь);

	Если НЕ Элементы.Список.РежимВыбора Тогда
		КП_ОбщееСервер.СохранитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ПоказыватьСхемуПроцессаВОбычномРежиме", ПоказыватьСхемуПроцессов, , Пользователь);
		
	Иначе
		КП_ОбщееСервер.СохранитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ПоказыватьСхемуПроцессаВРежимеВыбора", ПоказыватьСхемуПроцессов, , Пользователь);
																																											
	КонецЕсли;
	
	КП_ОбщееСервер.СохранитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ВыбранныйПроект", ВыбранныйПроект, , Пользователь);
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиСервером()
	
	Пользователь=СокрЛП(ТекущийПользователь);
		
	Если Элементы.Список.РежимВыбора Тогда
		ПоказыватьСхемуПроцессовЗначение=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ПоказыватьСхемуПроцессаВРежимеВыбора", , Пользователь);
		Если ПоказыватьСхемуПроцессовЗначение=Неопределено Тогда
			ПоказыватьСхемуПроцессов=Ложь;
		Иначе
			ПоказыватьСхемуПроцессов=ПоказыватьСхемуПроцессовЗначение;
		КонецЕсли;
		
	Иначе
		ПоказыватьСхемуПроцессовЗначение=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ПоказыватьСхемуПроцессаВОбычномРежиме", , Пользователь);
		Если ПоказыватьСхемуПроцессовЗначение=Неопределено Тогда
			ПоказыватьСхемуПроцессов=Истина;
		Иначе
			ПоказыватьСхемуПроцессов=ПоказыватьСхемуПроцессовЗначение;
		КонецЕсли;
		
	КонецЕсли;

	ПоказыватьСистемыеПроцессы=Ложь; //аДООбщееСервер.ЗагрузитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ПоказыватьСистемыеПроцессы", , Пользователь);
	
	Если ПолучитьФункциональнуюОпцию("УчетПоПроектам") Тогда
		ВыбранныйПроект=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("ВидыКорпоративныхПроцессов.ФормаСписка", "ВыбранныйПроект", , Пользователь);
		
	Иначе
		ВыбранныйПроект=Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСписок()
	
	Список.Параметры.УстановитьЗначениеПараметра("СистемныйВидПроцесса", ?(ПоказыватьСистемыеПроцессы, NULL, Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Проект", ?(ЗначениеЗаполнено(ВыбранныйПроект), ВыбранныйПроект, NULL));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКопиюПроцесса()
	ВидПроцесса=Элементы.Список.ТекущаяСтрока;
	
	#Если ТолстыйКлиент Тогда
	ЭтоГруппа=ВидПроцесса.ЭтоГруппа;
	#Иначе
	ЭтоГруппа=КП_ОбщееСервер.ПолучитьРеквизитОбъекта(ВидПроцесса, "ЭтоГруппа");
	#КонецЕсли

	Если ВидПроцесса=Неопределено ИЛИ ЭтоГруппа Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Сначала выберите строку с видом процесса.'"));
		Возврат;
	КонецЕсли;
	
	НовыйПроцесс=СкопироватьВидПроцесса(ВидПроцесса);
	
	Если ЗначениеЗаполнено(НовыйПроцесс) Тогда
		ПоказатьЗначение(Неопределено, НовыйПроцесс);
	КонецЕсли;
	
КонецПроцедуры

Функция СкопироватьВидПроцесса(ИсходныйВидПроцесса)
	
	НовыйПроцессОбъект=ИсходныйВидПроцесса.Скопировать();
	НовыйПроцессОбъект.Наименование=СокрЛП(ИсходныйВидПроцесса.Наименование)+" (Копия)";
	НовыйПроцессОбъект.Родитель=ИсходныйВидПроцесса.Родитель;
	
	Попытка
		НовыйПроцессОбъект.Записать();
		НовыйПроцесс=НовыйПроцессОбъект.Ссылка;
	Исключение
		ТекстОшибки="Ошибка записи нового процесса """+СокрЛП(НовыйПроцесс)+"""! "+ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		ЗаписьЖурналаРегистрации("Создание бизнес-процесса.", УровеньЖурналаРегистрации.Ошибка, ИсходныйВидПроцесса, , ТекстОшибки);
		Возврат Неопределено;
	КонецПопытки;
		
	//скопируем точки из вида в подпроцесс
	КП_СхемаКБПСервер.СкопироватьТочкиВидаВЭкземплярБП(ИсходныйВидПроцесса, НовыйПроцесс);
	
	//заполним маршрутную сеть процесса
	Если НЕ КП_СхемаКБПСервер.ЗаполнитьСетьМаршрутныхТочек(НовыйПроцессОбъект) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаИсходныхИНовыхРеквизитов=Новый ТаблицаЗначений;
	ТаблицаИсходныхИНовыхРеквизитов.Колонки.Добавить("ИсходныйРеквизит");
	ТаблицаИсходныхИНовыхРеквизитов.Колонки.Добавить("НовыйРеквизит");
	
	//создадим новые реквизиты
	Для Каждого СтрокаРеквизита Из НовыйПроцессОбъект.РеквизитыПроцессов Цикл
		
		РеквизитСсылка=СтрокаРеквизита.РеквизитПроцесса;
		Если РеквизитСсылка.Владелец=НовыйПроцесс Тогда
			//реквизит уже имеет корректного владельца
			Продолжить;
			
		КонецЕсли;
		
		НовыйРеквизитОбъект=РеквизитСсылка.Скопировать();
		НовыйРеквизитОбъект.Владелец=НовыйПроцесс;
		
		Попытка
			НовыйРеквизитОбъект.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Возврат Неопределено;
		КонецПопытки;
		
		СтрокаРеквизита.РеквизитПроцесса=НовыйРеквизитОбъект.Ссылка;
		
		СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Добавить();
		СтрокаТаблицы.ИсходныйРеквизит=РеквизитСсылка;
		СтрокаТаблицы.НовыйРеквизит=НовыйРеквизитОбъект.Ссылка;
		
	КонецЦикла;
	
	//заменим ссылки на реквизиты в точках процесса
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_ТочкиПроцессов.Ссылка
	                    |ИЗ
	                    |	Справочник.КП_ТочкиПроцессов КАК КП_ТочкиПроцессов
	                    |ГДЕ
	                    |	КП_ТочкиПроцессов.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_ТочкиПроцессов.ВладелецТочки = &ВладелецТочки");
						
	Запрос.УстановитьПараметр("ВладелецТочки", НовыйПроцесс);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		ТочкаВидаПроцесса=Выборка.Ссылка.ПолучитьОбъект();
		
		//найдем соответствие между исходным и новым реквизитом по сформированной ранее таблице
		ИсходныйРеквизит=ТочкаВидаПроцесса.РеквизитСИсполнителем;
		Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
			СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
			Если СтрокаТаблицы=Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
				Возврат Неопределено;
			КонецЕсли;
			ТочкаВидаПроцесса.РеквизитСИсполнителем=СтрокаТаблицы.НовыйРеквизит;
		КонецЕсли;
		
		ИсходныйРеквизит=ТочкаВидаПроцесса.ОбработкаРесурсыИспользоватьРеквизит;
		Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
			СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
			Если СтрокаТаблицы=Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
				Возврат Неопределено;
			КонецЕсли;
			ТочкаВидаПроцесса.ОбработкаРесурсыИспользоватьРеквизит=СтрокаТаблицы.НовыйРеквизит;
		КонецЕсли;
		
		ИсходныйРеквизит=ТочкаВидаПроцесса.ОбработкаРеквизитСДатой;
		Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
			СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
			Если СтрокаТаблицы=Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
				Возврат Неопределено;
			КонецЕсли;
			ТочкаВидаПроцесса.ОбработкаРеквизитСДатой=СтрокаТаблицы.НовыйРеквизит;
		КонецЕсли;	
		
		//заменим реквизиты в табличных частях
		Для Каждого СтрокаРеквизита Из ТочкаВидаПроцесса.РеквизитыПроцесса Цикл
			ИсходныйРеквизит=СтрокаРеквизита.РеквизитПроцесса;
			Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
				СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
				Если СтрокаТаблицы=Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
					Возврат Неопределено;
				КонецЕсли;
				СтрокаРеквизита.РеквизитПроцесса=СтрокаТаблицы.НовыйРеквизит;
			КонецЕсли;
		КонецЦикла;
		
		//передача в подпроцессы
		Для Каждого СтрокаРеквизита Из ТочкаВидаПроцесса.ПередачаРеквизитовВПодпроцесс Цикл
			ИсходныйРеквизит=СтрокаРеквизита.РеквизитПроцесса;
			Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
				СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
				Если СтрокаТаблицы=Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
					Возврат Неопределено;
				КонецЕсли;
				СтрокаРеквизита.РеквизитПроцесса=СтрокаТаблицы.НовыйРеквизит;
			КонецЕсли;
			
			ИсходныйРеквизит=СтрокаРеквизита.РеквизитПодпроцесса;
			Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
				СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
				Если СтрокаТаблицы=Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
					Возврат Неопределено;
				КонецЕсли;
				СтрокаРеквизита.РеквизитПодпроцесса=СтрокаТаблицы.НовыйРеквизит;
			КонецЕсли;			
			
		КонецЦикла;
		
		//установка реквизитов
		Для Каждого СтрокаРеквизита Из ТочкаВидаПроцесса.ОбработкаУстановкаРеквизитов Цикл
			ИсходныйРеквизит=СтрокаРеквизита.РеквизитПроцесса;
			Если ЗначениеЗаполнено(ИсходныйРеквизит) Тогда
				СтрокаТаблицы=ТаблицаИсходныхИНовыхРеквизитов.Найти(ИсходныйРеквизит, "ИсходныйРеквизит");
				Если СтрокаТаблицы=Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("en='Error matching details for ""';ru='Ошибка поиска соответствия реквизитов для ""'")+ИсходныйРеквизит+НСтр("ru='""';"));
					Возврат Неопределено;
				КонецЕсли;
				СтрокаРеквизита.РеквизитПроцесса=СтрокаТаблицы.НовыйРеквизит;
			КонецЕсли;
		КонецЦикла;
		
		
		
		Попытка
			ТочкаВидаПроцесса.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Возврат Неопределено;
		КонецПопытки;
				
	КонецЦикла;
	
	//запишем процесс
	Попытка
		НовыйПроцессОбъект.Записать();
		НовыйПроцесс=НовыйПроцессОбъект.Ссылка;
	
	Исключение
		ТекстОшибки="Ошибка записи нового процесса """+СокрЛП(НовыйПроцесс)+"""! "+ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		ЗаписьЖурналаРегистрации("Создание бизнес-процесса.", УровеньЖурналаРегистрации.Ошибка, ИсходныйВидПроцесса, , ТекстОшибки);
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат НовыйПроцесс;
	
КонецФункции

#КонецОбласти
